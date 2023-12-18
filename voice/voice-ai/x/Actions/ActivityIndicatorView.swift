import SwiftUI

struct ProgressViewComponent: View {
    @Binding var isShowing: Bool

    var body: some View {
        if isShowing {
            // An empty view with a semi-transparent background
            Color(hex: 0x1E1E1E).opacity(0.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
