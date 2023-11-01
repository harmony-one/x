=import SwiftUI
import SwiftData

@main
struct xApp: App {
    @StateObject var store = Store()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

//    var body: some Scene {
//        WindowGroup {
//            CheckoutView()
//        }
//        .modelContainer(sharedModelContainer)
//    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
