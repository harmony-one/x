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
        .buttonStyle(PressEffectButtonStyle(active: active, invertColors: button.action == .speak))
    }
}

let COLOR_ACTIVE = Color(hex: 0x0088B0)
let COLOR_DEFAULT = Color(hex: 0xDDF6FF)

struct PressEffectButtonStyle: ButtonStyle {
    
    var background: Color?
    var active: Bool = false
    var invertColors: Bool = false
    
    init(background: Color? = nil, active: Bool = false, invertColors: Bool = false) {
        self.background = background
        self.active = active
        self.invertColors = invertColors
    }
    
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .background(background ?? determineBackgroundColor(configuration: configuration))
                .foregroundColor(determineForegroundColor(configuration: configuration))
                .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
        }
    
    // .speak button should have inverted colors
    // .play button should have the "pressed" color while pause / play is in process
    // this is the only case as of now that uses self.active to determined the colors
    // all other buttons(including .speak) should be triggered through configuration.isPressed
    
    private func determineBackgroundColor(configuration: Configuration) -> Color {
        if invertColors {
            return configuration.isPressed || self.active ? COLOR_DEFAULT : COLOR_ACTIVE
        } else {
            return configuration.isPressed || self.active ? COLOR_ACTIVE : COLOR_DEFAULT
        }
    }

    private func determineForegroundColor(configuration: Configuration) -> Color {
        if invertColors {
            return configuration.isPressed || self.active ? COLOR_ACTIVE : COLOR_DEFAULT
        } else {
            return configuration.isPressed || self.active ? COLOR_DEFAULT : COLOR_ACTIVE
        }
    }
}
