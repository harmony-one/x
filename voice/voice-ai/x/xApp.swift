import Sentry
import SentrySwiftUI
import SwiftData
import SwiftUI

@main
struct xApp: App {
    @StateObject var store = Store()
    @StateObject var appSettings = AppSettings()
    let appConfig = AppConfig.shared
    init() {
        // Initialize ReviewRequester with values from AppConfig
        ReviewRequester.initialize(
            minimumSignificantEvents: appConfig.getMinimumSignificantEvents() ?? 5,
            daysBetweenPrompts: appConfig.getDaysBetweenPrompts() ?? 120
        )

        guard let sentryDSN = appConfig.getSentryDSN() else {
            return
        }

        SentrySDK.start { options in
            options.dsn = sentryDSN
            options.enableUIViewControllerTracing = true
        }
    }

    var body: some Scene {
        WindowGroup {
            // Currently we are displaying only buttons
            //  DashboardView()
            SentryTracedView("ActionsView") {
                ActionsView()
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
