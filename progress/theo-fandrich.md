2023-11-30 Thu: Released v1.1130.18 to testflight and submitted to app store. We have added a new submenu and reconfigured delete account functionality to receive app store approval.

2023-11-29 Wed: Released v1.1130.9 which now handles account deletion which should resolve App Store approval. Mixpanel should be integrated by Monday so that we can have full behavioral tracking of app. Data.ai and Sensor Tower only repackage the data that is shared within App Connect, so it doesn't provide any granular detail to the user experience.

2023-11-28 Tue: Released v1.1128.9 in the morning with optimizations to button interactions and unit tests. More backend logic will need to be implemented to handle in-App Purchases in production and prompting the user to update to the newest version.

2023-11-27 Mon: v1.1124.13 was finally approved by the App store. This includes new button handling, share transcript button, and updating overall user experience.

---

2023-11-26 Sun: Version v1.1124.13 was rejected due to app incompleteness which was simply just oversight from the app store team. I have resubmitted an even more updated version with proper feedback.

2023-11-25 Sat: Did minor product testing and resolved local issues regarding the linter we are using for static analysis.

2023-11-24 Fri: Deployed v1.1124.13 to the app store which includes the new more actions button, disabled long press functionality, and resolved bugs related to button interactions. 

2023-11-22 Wed: Deployed v1.1122.9 to both Voice AI and Voice 2 internal testflights for testing. 

2023-11-21 Tue: We will be launching v1.1122.9 to the app store tomorrow morning after button handling is satisfied. Many of the functionality still hangs when under stress testing, especially when multiple buttons are pressed simultaneously.

2023-11-20 Mon: We finally received approval after 4 days for v1.1120.13. We have submitted a new build with in-App Purchase to solicit feedback from Apple.

---

2023-11-17 Fri: We had 99 total downloads and ~80 total active devices! Unique addresses that called our auth server and received keys was 126. We have deployed 1.1117.9 internal build (“Voice 2”).

2023-11-16 Thu: iOS App Version 1.1115.18 is now available in the App Store, please share this with family, friends, & enemies, as we aim to reach 40 active users by Sunday! At the end of the day, we released 1.1116.18 which has been submitted to the app store for approval, there were 8 active users yesterday.

2023-11-15 Wed: We have released version 1.1115.18 (versioning: 1.MDD.HH). Testing of in-App Purchase (IAP) functionality is underway and should be submitted to App Store Approval by Friday 3pm. We expect to have 40+ daily active users by Sunday morning. Yesterday, we had 8 users; this was mostly due to us disability the app due to a security vulnerability that has now been resolved.

2023-11-14 Tue: Built version 0.9.20. Since launch 5 days ago, we have accumulated 183 downloads with a conversion rate of 15%+ of Product Page Views. 68% of our downloads have been from organic App Store Search. Today's active daily users were only 10, we will strategize to increase retention.

2023-11-13 Mon: Worked with Frank on testing custom instructions, this is almost complete and just needs review from Nagesh. Submitted 1.0.6 to App Store review which includes our first build with in App purchases.

---

2023-11-08 Fri: Tested multiple pull requests and deployed build to testflight.

2023-11-08 Thu: This was our first day getting App Store approval, worked diligently to resolve any blatant issues regarding promotional texts, images, and other inconsistencies.

2023-11-08 Wed: Continued to research apple store guidelines, test developer's code, and deploy to testflight.

2023-11-07 Tue: Product tested, listed out bugs, delegated fixes to engineers, submitted to App store connect.

2023-11-06 Mon: Worked on preparing app store submission. Calculated pricing for Voice AI and documented how the backend and iOS app should communicate to support the bahavior. The updated UI will be implemented by Tuesday morning.

---

2023-11-05 Sun: Tested new Tested various implementations of Sun's chunking and built to testflight. Coordinated and noted behavioral bugs for remote engineers to fix. Worked on generating and researching a solution for the limitation on the internal test codes. 

2023-11-03 Fri: Organized information for beta and app store submission [here](https://www.notion.so/harmonyone/App-Store-Beta-Submission-a0ad78ce2bd44460aa61a15a58314d0a).

2023-11-02 Thu: Conducted thorough product testing and generated testflight codes for demo day.

2023-11-01 Wed: (Birthday Progress report) - Debugged Voice AI app and coordinated deployment of v0.8.7 and v0.8.8. Set up 10+ email aliases to prepare App Store Connect account for redemption codes.

2023-10-31 Tue: Looked through Apple Guidelines for pushing an application to appstore, compiled some of the more relevant ones [here](https://www.notion.so/harmonyone/App-Store-Review-999af4a573284e2c90f54723d0227532).

2023-10-30 Mon: Coordinated update v0.8.4 with streaming. Accessed and setup internal apple store development account and will prepare for transition tomorrow. Helped Rika onboard to testflight, test out Whisper App, and reviewed some of her goals.

---

2023-10-29 Sun: Prepared tasks for engineers by testing out PRs and organizing kanban. Streaming works, but button functionality has too many bugs to merge branch still, listed some of the more peritenent issues [here](https://www.notion.so/harmonyone/Kanban-2aff109a6221488081bb99c0d2470d91?p=6b34ab5846484b47ba32b42ee4ecd661&pm=s). Team members should complete unit testing set up by Tuesday based off of Nagesh's [template](https://github.com/harmony-one/x/pull/85) he created today.

2023-10-28 Sat: Reviewed Yuriy's streaming [PR](https://github.com/harmony-one/x/pull/84/files), unfortunately there are still some bugs that are introduced with this PR, so will continue to work with Yuriy, Sun, and Aaron to have this implemented. 

2023-10-27 Fri: Worked on draft of delegating unit testing, component testing, and end-to-end testing for Voice AI with Sun ([doc](https://www.notion.so/harmonyone/Kanban-2aff109a6221488081bb99c0d2470d91?p=25ebd29796fe4848b8835b11828b83d1&pm=s)). I expired all previous builds and deployed 0.8.2 build with proper versioning and provided notes for updates regarding the 9am build version 0.8.2. Theo and I will be collecting feedback for daily testing of whisper app and voice ai app ([doc](https://www.notion.so/harmonyone/Kanban-2aff109a6221488081bb99c0d2470d91?p=56121e87272843bab0bfe2ead2f57bd8&pm=s)).

2023-10-26 Thu: Conducted 15 minutes testing of Whipser App and Voice AI App, left comments [here](https://www.notion.so/harmonyone/Fandrich-caf2da5319354c31bf686efa20127744). Produced [cost analysis model](https://docs.google.com/spreadsheets/d/1s_QkGFYi07__PxPGLIUeIrAB_ZyONa2iq9kpWhF-M-0/edit#gid=0) to quickly analyze price per minute for different language models and voice models.

2023-10-25 Wed: iOS 16 support will be available by Thursday 10/26, and we should have our own apple support development account available upon Apple's approval so we can deploy our first app for wider testing. Left new tasks for bugs discovered, specifically for handling outstanding network responses overlapping with new user requests ("random fact", "press to talk").

2023-10-24 Tue: We are on our way to having a 5-min functional demo by Friday. Some of the current tasks/bugs/fixes that are underway: Custom Instruction implementations through system settings, streaming audio with chatGPT4 and built in iphone audio synthesis, haptic feedback for improved user experience, and makeover for all buttons. Unit testing and linter will be implemented in the next 7 days as well to streamline and optimize the output of production code.

2023-10-23 Mon: Preparing Frank, Sergey, and Artem's apps for full end to end deploy which should be ready by 9am Tueday morning. Alaina and I will work to prepare a blog post for 1bot.

---

2023-10-22 Sun: Deployed xCode build for Hey Anne and reconfigured so that all naming conventions matched. I uppdated the temporary logo, openAI API key, and documented how and where to create Appconfig folder [here](https://www.notion.so/harmonyone/Help-d3df4ffd40fc46a1abe77e598a8a195e).

2023-10-21 Sat: Worked on debugging xCode build with Sergey, Nagesh, and Aaron to completed end to end build for Hey Eve. Communicated [/press-build](https://www.x.country/voice-ai-talk-to-chatgpt4-as-your-subject-professor-language-buddy-or-streaming-wikipedian-9525f3738a9f405f9238d1e79dab1dd2) to Nagesh who said he can have it complete by Monday.

2023-10-20 Fri: Worked with Frank on group whitelist, tested, and will deploy Friday 7pm. Coordinated with Aaron and Julia to document how to deploy current fission labs fork to testflight app. Organized future tasks on [kanban](https://www.notion.so/harmonyone/Kanban-2aff109a6221488081bb99c0d2470d91) for ios "streaming build" which artem & sergey, and edge build, which Nagesh from Fission labs is working on.

2023-10-19 Thu: Will work with Sun/Yuriy tomorrow to help set up and benchmark Play.ht, Google, Azure tomorrow [here](https://yuriy.x.country/). Will work with Aaron, Julia, Nagesh, and Sergey to push out several IOS demos in the coming days. Will work with artem on his [demo](artem.x.country), to optimize stream handeling of chatGPT and both speech-to-text module and text-to-speech module.

2023-10-18 Wed: Developed executable steps for engineers. Researched more SST, worked with Sun on benchmarking. Helped set up email aliases. Connected with a few folks at AI voice event. Yuriy is implementing Play.ht's fast new TTS.

2023-10-17 Tue: Read more, wrote more, and organized more. Continued to test sam.x.country and artem.x.country and spent 30 minutes playing with new openAI chat. Communicated to devs new builds and worked through determing how to execute new features and remove bugs.

2023-10-16 Mon: Throughouly tested artem.x.country (currently a bug where there is no audio in production). Interruptions has been implemented and chatGPT4 context has been integrated. Next steps is to more seemlessly handle streaming and handle bugs. Tested yuriy.x.country (credentials need to be set up).

---

2023-10-13 Fri: Spoke with ios engs, tested new demos, deployed them, will map them to x.country domains tomorrow. Will continue to research resemble, play.ht, and other projects over the weekend and push the development of all demos.

2023-10-12 Thu: Helped test and deploy https://x.country/gdansk fork for Yuriy and another unhosted demo using vocode with Sergey. Helped reformat main demo, and will have call with our new ios eng tomorrow at 9:30am

2023-10-11 Wed: Negotiated contract with fissionlabs, will complete 10/12 (thu). Researched forkable [demos](https://github.com/jmaczan/gdansk-ai#-gda%C5%84sk-ai-) for deploy. 





