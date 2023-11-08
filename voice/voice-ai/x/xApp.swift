import SwiftUI
import SwiftData
import Sentry
import SentrySwiftUI

@main
struct xApp: App {
    @StateObject var store = Store()
    var body: some Scene {
        WindowGroup {
            // Currently we are displaying only buttons
            //  DashboardView()
            SentryTracedView("ActionsView"){
                ActionsView().environmentObject(store).background(Color(hex: 0xDDF6FF).animation(.none))
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
