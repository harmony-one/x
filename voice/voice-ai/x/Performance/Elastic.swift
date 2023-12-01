import ElasticSwiftNetworkingNIO
import Sentry
import ElasticSwift
import ElasticSwiftNetworking

struct CustomSource: Codable, Equatable {
    var value: String
}

class Elastic {
    var client: ElasticClient!
    
    init() {
        var appSettings = AppSettings()
        let appConfig = AppConfig.shared
        
        guard let elasticUrl = appConfig.getElasticUrl() else {
            return
        }
        
        guard let elasticLogin = appConfig.getElasticLogin() else {
            return
        }
        
        guard let elasticPassword = appConfig.getElasticPassword() else {
            return
        }
        
        let cred = BasicClientCredential(username: elasticLogin, password: elasticPassword)
        
        let settings = Settings(forHost: elasticUrl, withCredentials: cred, adaptorConfig: AsyncHTTPClientAdaptorConfiguration.default)
        
        client = ElasticClient(settings: settings) // Creates client with specified settings
    }
    
    // index document
    func indexHandler(_ result: Result<IndexResponse, Error>) -> Void {
        switch result {
            case .failure(let error):
                print("Error", error)
            case .success(let response):
                print("Response", response)
        }
    }

    func index(value: String) {
        if(client == nil) {
            return
        }
        
        do {
            let source = CustomSource(value: value)

            let indexRequest = try IndexRequestBuilder<CustomSource>()
                .set(index: "timeIndex")
                .set(id: "id")
                .set(source: source)
                .build()

            client.index(indexRequest, completionHandler: self.indexHandler)
            
        } catch {
            SentrySDK.capture(message: "Error Elastic indexRequest \(error)")
        }
    }
}
