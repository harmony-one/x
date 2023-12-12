import SwiftUI

struct ProgressViewComponent: View {
    @Binding var isShowing: Bool

    var body: some View {
        if isShowing {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(hex: 0x1E1E1E).opacity(0.5))
                .edgesIgnoringSafeArea(.all)
        }
    }
}
