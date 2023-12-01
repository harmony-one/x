import Mixpanel
import Sentry

class MixpanelManager {
    static let shared = MixpanelManager()
    
    private init() {
        guard let mixpanelToken = AppConfig.shared.getMixpanelToken() else {
            SentrySDK.capture(message: "Missing Mixpanel Token")
            print("[MixpanelManager] Missing Mixpanel Token")
            return
        }
        Mixpanel.initialize(token: mixpanelToken, trackAutomaticEvents: true)
    }
    
    func trackEvent(name: String, properties: [String: MixpanelType]?) {
        Mixpanel.mainInstance().track(event: name, properties: properties)
    }
}