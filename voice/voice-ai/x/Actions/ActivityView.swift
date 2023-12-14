import SwiftUI

struct ShareLink: Identifiable {
    let id = UUID()
    let title: String
    let url: URL
}

protocol ActivityViewProtocol: UIViewControllerRepresentable { //
    var activityItems: [Any] { get }
    var applicationActivities: [UIActivity]? { get }

    func makeUIViewController(context: Context) -> UIActivityViewController
    
}

struct ActivityView: ActivityViewProtocol, UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]?
    @Binding var isSharing: Bool

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.completionWithItemsHandler = { _, _, _, _ in
            self.isSharing = false  // Hide activity indicator when sharing is done
        }
        return controller
    }

    func updateUIViewController(_: UIActivityViewController, context: Context) {}
}
