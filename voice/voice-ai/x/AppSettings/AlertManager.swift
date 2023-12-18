import UIKit

class AlertManager {

    private var viewControllerProvider: () -> UIViewController?

    // Dependency Injection via initializer
    init(viewControllerProvider: @escaping () -> UIViewController?) {
        self.viewControllerProvider = viewControllerProvider
    }

    func showAlertForSettings(title: String, message: String, actions: [UIAlertAction]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                guard let viewController = self.viewControllerProvider() else {
                    print("No view controller provided for presenting the alert")
                    return
                }

                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                for action in actions {
                    alert.addAction(action)
                }

                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
}
