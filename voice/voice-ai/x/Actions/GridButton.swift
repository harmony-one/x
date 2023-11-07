import Foundation
import SwiftUI

struct GridButton: View {
    var button: ButtonData
    var foregroundColor: Color
    var active: Bool = false;
    var colorExternalManage: Bool = false;
    var action: () -> Void
    @State private var isPlayPressed: Bool = false
    @State private var isSpeakPressed: Bool = false
    let buttonSize: CGFloat = 100
    let imageTextSpacing: CGFloat = 40
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        Button(action: {
            switch button.action {
            case .play where active:
                self.isPlayPressed.toggle()
            case .speak where active:
                self.isSpeakPressed.toggle()
            case .reset:
                self.isPlayPressed = false
                self.isSpeakPressed = false
            default:
                break
            }
            action()
        }) {
            VStack(spacing: imageTextSpacing) {
                Image(pressEffectButtonImage()) // button.image)
                    .fixedSize()
                    .aspectRatio(contentMode: .fit)
                Text(button.label)
                    .font(.customFont(size: 11))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(0)
            .alignmentGuide(.bottom) { _ in 0.5 }
        }
        .buttonStyle(PressEffectButtonStyle(active: active, invertColors: button.action == .speak))
    }

    private func pressEffectButtonImage() -> String {
        let themePrefix = "blackred -"
        switch button.action {
        case .play where active:
            return self.isPlayPressed ? "\(themePrefix) play" : "\(themePrefix) pause play"
        case .speak where active:
            return self.isSpeakPressed ? "\(themePrefix) press & hold pressed" : "\(themePrefix) press & hold"
        default:
            return button.image
        }
    }
}

let COLOR_ACTIVE = Color (hex: 0xD7303A) // Color (hex: 0xFFFFFF) // Color (hex: 0xD7303A) // Color(hex: 0x0088B0)
let COLOR_DEFAULT = Color (hex: 0x1E1E1E) // Color(hex: 0xDDF6FF)

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
        let isPressed =  self.active || configuration.isPressed
        
        if invertColors {
            return isPressed ? COLOR_DEFAULT : COLOR_ACTIVE
        } else {
            return isPressed ? COLOR_ACTIVE : COLOR_DEFAULT
        }
    }

    private func determineForegroundColor(configuration: Configuration) -> Color {
        let isPressed =  self.active || configuration.isPressed
        
        if invertColors {
            return isPressed ? COLOR_ACTIVE : COLOR_DEFAULT
        } else {
            return isPressed ? COLOR_DEFAULT : COLOR_ACTIVE
        }
    }
}
