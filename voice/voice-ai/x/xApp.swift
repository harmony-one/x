import Sentry
import SentrySwiftUI
import SwiftData
import SwiftUI

@main
struct XApp: App {
    @StateObject var store = Store()
    @StateObject var appSettings = AppSettings()
    var actionHandler: ActionHandler = .init()
    let appConfig = AppConfig.shared
    var mixpanel = MixpanelManager.shared
    init() {
        // Initialize ReviewRequester with values from AppConfig
        ReviewRequester.initialize(
            minimumSignificantEvents: appConfig.getMinimumSignificantEvents() ?? 5,
            daysBetweenPrompts: appConfig.getDaysBetweenPrompts() ?? 120
        )
        
        IntentManager.shared.setActionHandler(actionHandler: self.actionHandler)

        guard let sentryDSN = appConfig.getSentryDSN() else {
            return
        }

        SentrySDK.start { options in
            options.dsn = sentryDSN
            options.enableUIViewControllerTracing = true
            
            // Example uniform sample rate: capture 100% of transactions
            // In Production you will probably want a smaller number such as 0.5 for 50%
            options.tracesSampleRate = 1.0

        #if DEBUG
        options.environment = "testing"
        #else
        options.environment = "production"
        #endif
        }
    }

    var body: some Scene {
        WindowGroup {
            // Currently we are displaying only buttons
            //  DashboardView()
            SentryTracedView("ActionsView") {
                ActionsView(actionHandler: actionHandler)
                    .environmentObject(store)
                    .environmentObject(appSettings)
                    .background(Color(hex: 0x1E1E1E).animation(.none))
                    .overlay {
                        SettingsView()
                            .environmentObject(store)
                            .environmentObject(appSettings)
                    }
            }
        }
    }
}
