import UIKit

struct AlertManager {
    
 static func showAlertForSettings(title: String, message: String, actions: [UIAlertAction]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
                    print("No active window scene found")
                    return
                }
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                for action in actions {
                    alert.addAction(action)
                }
                
                if let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController {
                    rootViewController.present(alert, animated: true, completion: nil)
                } else {
                    print("No root view controller found to present the alert")
                }
            }
        }
    }
    
}
