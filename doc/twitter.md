## Personalized Response

For users to get up-to-date responses tailored to their topics of interest (e.g. queries akin to "What's new with Tesla?"), we need to retrieve the relevant information and put them as contexts in chat completion queries. In the initial version, we can achieve that simply by pulling tweets from X (formerly Twitter) based on predefined topics the user configured. In later iterations, we can add other major sources of information such as Reddit and Quora. In this document we will focus on integrations with X only.

After the relevant information is retrieved, it can be added as context (prior messages) in chat completion inference queries, followed by a prompt instruction for the functionality we want to achieve, e.g. "Based on the tweets collected above, please summarize what is new with Tesla". 

## Acquiring X Data

For many years, X is known to be difficult to work with even for sophisticated web crawlers. Access to data was achieved by Twitter API, which was free for majority of use cases (including streaming Tweets based on hashtags), and a few thousand dollars per month for "enterprise" use case where sophisticated filters, most recent data, and historical data for arbitrary time range were offered through "Twitter Firehose".

Since 2022, X no longer provides free API access to data. Even for paid version, data access became very restricted:

### Total monthly post volume [restriction](https://developer.twitter.com/en/docs/twitter-api/getting-started/about-twitter-api):

- No more than 10000 posts can be pulled in basic plan ($100 per month)
- No more than 1M posts can be pulled in pro plan ($5000 per month)
- Enterprise version may allow higher limit but it can be expected to be very pricey.

### API Rate limit [restriction](https://developer.twitter.com/en/docs/twitter-api/rate-limits)

Rate limit is accounted separately for based on whether a query can be attributed to a user. A query can only be attributed to a user when it is called using an access token unique to a user, which is only issued after the user authenticate and authorize the app to act on its behalf ([OAuth 1.0a](https://developer.twitter.com/en/docs/authentication/oauth-1-0a), which is deprecated and has restricted API access, and [OAuth 2.0 Authorization Code Flow with PKCE](https://developer.twitter.com/en/docs/authentication/oauth-2-0/authorization-code)). 

The most relevant API is looking up recent tweets (using arbitrary [query](https://developer.twitter.com/en/docs/twitter-api/tweets/search/integrate/build-a-query)): 

- basic plan: 60 queries per 15 minutes per app and per user
- pro plan: 450 queries per 15 minutes per app, 300 queries per 15 minutes per user 

Another very relevant API is getting posts from a [List](https://help.twitter.com/en/using-x/x-lists). A List is used to group posts from members in the list, and can be followed by anyone just like a regular account. Anyone can create and manage their lists and add anyone as member. However, anyone can also remove themselves as a member from any list if they want, and block the list so that they can no longer be added to that list again.

- basic plan: 5 queries per 15 minutes per user, 25 queries per 15 minutes per app
- pro plan: 900 queries per 15 minutes per user and app

### Data Acquisition Implementation and Product Feature Limitation

Given the above limitations, a natural strategy for us is to at first only make minimal queries on server and only using List, since in the initial versions of the product, we only provide a small list of topics for the users to choose from (e.g. Bitcoin, Tesla, Apple, Google, Facebook, ONE). The members in each List can be manually curated and managed by us. By doing so, we would not need users to connect their X account to the app, which significantly reduces the friction for onboarding users to this product feature.

In later versions of the app, when users are allowed to pick a broad range of topics, following the account they choose, or using hashtags freely, we would have to require the user to go through OAuth 2.0 flow and connect their X account to the app. On their phone, the Voice AI app would redirect the user to the X app where a sheet would appear asking the user to authorize the app with a small list of permission scopes (reading posts, reading lists, and doing it "offline"). After the user responds, they would be redirected back to the Voice AI app. Note that we need to associate the domain of the Voice AI app with the OAuth callback URL, otherwise the user would be redirected back to a browser window instead of the Voice AI app.  

We may evolve the implementation as the following:

- When the number of topics available for the user to choose is less than 25, acquire latest post data using List for each topic every 15 minutes on the server.
  - The API is [GET /2/lists/:id/tweets](https://developer.twitter.com/en/docs/twitter-api/lists/list-tweets/api-reference/get-lists-id-tweets). Since we intend to consume app rate limit instead of acting as a user, we may call the API using only a [Bearer token](https://developer.twitter.com/en/docs/authentication/oauth-2-0/bearer-tokens) on the server, which can be stored as environment variable.
  - If a topic require a higher update frequency, it can count as 2, 3, 4, or more topics, and its update frequency can be improved to every 7.5, or 5, or 3.75, or fewer minutes accordingly. 
  - If a topic does not need to be updated as frequently, we may skip pulling that topic for a few times to give rooms for other topics in high demand. Statistically in this scenario they can be counted as a fraction of a topic (e.g. 0.5, 0.33, ...) but in the implementation we need to be careful and count them as 1 when pulling occurs, and 0 when it does not occur, and always take precautions to ensure we never exceed the rate limits.
- If the user wants to choose topics outside of the predefined topics (Lists we curated), they would have to login following the OAuth 2.0 flow. At the end of the flow, the server will be given an [access token](https://github.com/twitterdev/twitter-api-typescript-sdk/blob/0d12a20a76d6dd9c346decf9cc80bc611975d43f/src/OAuth2User.ts#L169) (see also usage [example](https://github.com/twitterdev/twitter-api-typescript-sdk/blob/0d12a20a76d6dd9c346decf9cc80bc611975d43f/examples/oauth2-callback.ts#L27)). The token should be stored in the database. Whenever required, the server can load the token and [act on behalf as the user](https://developer.twitter.com/en/docs/authentication/oauth-2-0/user-access-token) as a confidential client (using basic authentication scheme, i.e. "Authorization" header with "Basic: " as value followed by the token) to retrieve the latest posts about the topic
  - The retrieved data should be cached and persisted at the server, so the same query need not to be made multiple times within a short amount of time (e.g. 5 minutes). Additionally, later queries should request posts only after the previous query's timestamp. Doing so will allow us to save a significant amount of monthly quota for posts
  - If the topic the user chooses can be associated with a List, we should use the List Posts Lookup API (`GET /2/lists/:id/tweets`). At the server, we may manually maintain a database of Lists covering a wide range of topics, label them in a way we see fit, and expose an API to retrieve this list or search / autocomplete the labels. In the app, we may use the exposed API to let the user choose from the Lists we have in the database
  - If the topic the user chooses is a hashtag or an account, the Search Recent Posts API [GET /2/tweets/search/recent](https://developer.twitter.com/en/docs/twitter-api/tweets/search/api-reference/get-tweets-search-recent) should be used. A query needs to be [constructed](https://developer.twitter.com/en/docs/twitter-api/tweets/search/integrate/build-a-query) for that purpose at the server.

### System Components and Libraries

#### Data Server

The Data Server should expose several APIs for the app client. It should operate in as a standalone server separate to the Relay, to avoid contention on computing resources. 

- `GET /topics` - return a list of topic object to the client. Each topic should at least consists of id, icon, description, updateFrequency, and label
- `GET /topics/:id` - return the latest posts of a particular topic. Each post object needs not to follow X's format. Instead, we should define a simple format

The above APIs are sufficient for the initial version. In later versions, we can add the following

- `GET /callback` - where X server would redirect the user to complete the OAuth login flow. The server should persist access token, issue a temporary client authentication token (for the app to call server API), and redirect the user to the app client with the authentication token included in query parameter.
- `GET /topics/hashtag/:hashtag` - return the latest posts of a particular hashtag
- `GET /topics/hashtag/:account` - return the latest posts of a particular X account

Note that in future versions of the design, we may have the Relay to call the server for data acquisition instead of using the app client. This enhances security and potentially allows more complex processing and transformation of the data before sending them for inference.

We may also need to validate incoming requests are legitimate. To avoid redundant implementations, the Relay could provide an API for this purpose. The same tokens for authenticating with Relay can be used for the API calls here.

A standard Typescript-based Express.js server is sufficient. An official Typescript SDK for X API calls is available at https://github.com/twitterdev/twitter-api-typescript-sdk

The server should also periodically call X APIs to retrieve latest posts for each topic based on the topic's update frequency. The results should be persisted in database (discussed below)

### Database

Two databases should be used. A simple relational database such as MySQL should be used for storing list of topics, user's access tokens, and their association with user's X account (and Apple ID, if needed) and temporary authentication tokens. A non-relational document database such as ElasticSearch should be used to persist queries received from API, made to X, and posts retrieved from queries.  

In the initial version, we can start with simple in-memory cache and launch first. We may implement ElasticSearch after we need to optimize and analyze the results. We do not need to implement for MySQL until versions involving OAuth and custom topics are done.

### App Client

There is no significant change aside from some UI updates, an additional endpoint URL for AppConfig (can be bundled in RelaySettings retrievable from Relay), and an additional class that interacts with the Data Server. 

A Swift based library is available for OAuth and calling X APIs, but it is unlikely we will need to use it at all: https://github.com/daneden/Twift/