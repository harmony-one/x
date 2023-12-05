import Mixpanel
import Sentry

class MixpanelManager {
    static let shared = MixpanelManager()
    private var lastTrackedEvent: String?
    
    private init() {
        guard let mixpanelToken = AppConfig.shared.getMixpanelToken() else {
            SentrySDK.capture(message: "Missing Mixpanel Token")
            print("[MixpanelManager] Missing Mixpanel Token")
            return
        }
        initializeMixpanel(withToken: mixpanelToken)
    }
    
    func initializeMixpanel(withToken mixpanelToken: String) {
            Mixpanel.initialize(token: mixpanelToken, trackAutomaticEvents: true)
        }
    
    func trackEvent(name: String, properties: [String: MixpanelType]?) {
        DispatchQueue.global(qos: .background).async {
            Mixpanel.mainInstance().track(event: name, properties: properties)
            self.lastTrackedEvent = name
        }
    }
    
    func getLastTrackedEvent() -> String? {
        return lastTrackedEvent
   }
}
