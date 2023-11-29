import Foundation
import SwiftUI
import Combine

class VersionManager: ObservableObject {
    static let shared = VersionManager()
    var latestVersion: String?
    @Published var updateAvailable = false
    
    func checkForUpdates() {
        getUserAppVersion { [weak self] success in
            guard success,
                  let self = self,
                  let latestVersion = self.latestVersion,
                  let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
                  self.isVersion(currentVersion, lessThan: latestVersion) else {
                return
            }
            DispatchQueue.main.async {
                self.updateAvailable = true
            }
        }
    }
    
    private func isVersion(_ oldVersion: String, lessThan newVersion: String) -> Bool {
        return oldVersion.compare(newVersion, options: .numeric) == .orderedAscending
    }
    
    func getUserAppVersion(completion: @escaping (Bool) -> Void) {
        NetworkManager.shared.requestData(from: APIEnvironment.getUserAppVersion(), method: .get) { (result: Result<NetworkResponse<User>, NetworkError>) in
            switch result {
            case .success(let response):
                print("Status Code: \(response.statusCode)")
                // self?.latestVersion = response.data.appVersion
                completion(true)
            case .failure(let error):
                print("Error: \(error)")
                completion(false)
            }
        }
    }
    
    // Function to present the upgrade alert
    func presentUpdateAlert() -> Alert {
        return Alert(
            title: Text("Update Available"),
            message: Text("A new version of the app is available. Please update to the latest version."),
            primaryButton: .default(Text("Upgrade")) {
                // Redirect to App Store
                if let url = URL(string: "https://apps.apple.com/app/id6470936896"),
                   UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            },
            secondaryButton: .cancel {
                self.updateAvailable = false
            }
        )
    }
}
