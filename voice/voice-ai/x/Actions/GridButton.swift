import Foundation
import SwiftUI

struct GridButton: View {
    var button: ButtonData
    var geometry: GeometryProxy
    var foregroundColor: Color
    var active: Bool = false;
    var colorExternalManage: Bool = false;
    var action: () -> Void

    
    let buttonSize: CGFloat = 100
    let imageTextSpacing: CGFloat = 40
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        Button(action: action) {
            VStack(spacing: imageTextSpacing) {
                Image(button.image)
                    .fixedSize()
                    .aspectRatio(contentMode: .fit)
                Text(button.label)
                    .font(.customFont(size: 11))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(
                width: geometry.size.width / CGFloat(verticalSizeClass == .compact ? 3 : 2),
                height: geometry.size.height / CGFloat(verticalSizeClass == .compact ? 2 : 3)
            )
            .cornerRadius(0)
            .alignmentGuide(.bottom) { _ in 0.5 }
        }
        .buttonStyle(PressEffectButtonStyle(active: active, colorExternalManage: colorExternalManage))
    }
}

let COLOR_ACTIVE = Color(hex: 0x0088B0)
let COLOR_DEFAULT = Color(hex: 0xDDF6FF)

struct PressEffectButtonStyle: ButtonStyle {
    
    var background: Color?
    var active: Bool = false
    var colorExternalManage: Bool = false
    
    init(background: Color? = nil, active: Bool = false, colorExternalManage: Bool = false) {
        self.background = background
        self.active = active
        self.colorExternalManage = colorExternalManage
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(background ?? ((!self.colorExternalManage && configuration.isPressed) || self.active ? COLOR_ACTIVE : COLOR_DEFAULT))
            .foregroundColor((!self.colorExternalManage && configuration.isPressed) || self.active ? COLOR_DEFAULT : COLOR_ACTIVE)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
