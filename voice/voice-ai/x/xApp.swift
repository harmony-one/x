import SwiftUI
import SwiftData
import Sentry
import SentrySwiftUI

@main
struct xApp: App {
    @StateObject var store = Store()
    let appConfig =  AppConfig.shared
    init() {
         // Initialize ReviewRequester with values from AppConfig
         ReviewRequester.initialize(
            minimumSignificantEvents: appConfig.getMinimumSignificantEvents() ?? 5,
            daysBetweenPrompts: appConfig.getDaysBetweenPrompts() ?? 120
         )
     }

    var body: some Scene {
        WindowGroup {
            // Currently we are displaying only buttons
            //  DashboardView()
            SentryTracedView("ActionsView"){
                ActionsView().environmentObject(store).background(Color(hex: 0x1E1E1E).animation(.none))
            }
        }
    }
    
    init() {
        let config = AppConfig()
        
        guard let sentryDSN = config.getSentryDSN() else  {
            return
        }
        
        SentrySDK.start { options in
            options.dsn = sentryDSN
            options.enableUIViewControllerTracing = true
        }
     }
}
