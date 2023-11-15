import Foundation
import SwiftUI

struct GridButton: View {
    var currentTheme: Theme
    var button: ButtonData
    var foregroundColor: Color
    var active: Bool = false
    var isPressed: Bool = false
    var image: String? = nil
    var colorExternalManage: Bool = false
    var action: () -> Void
    let buttonSize: CGFloat = 100
    let imageTextSpacing: CGFloat = 40
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var debounce_timer:Timer?

    var body: some View {
        Button(action: {
            self.debounce_timer?.invalidate()
            self.debounce_timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                action()
            }
        }) {
            VStack(spacing: imageTextSpacing) {
                Image(pressEffectButtonImage()) // button.image)
                    .fixedSize()
                    .aspectRatio(contentMode: .fit)
                Text(getLabel())
                    .font(.customFont(size: 11))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .animation(Animation.easeOut(duration: 0.5), value: true)
                    // .animation(nil  )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(0)
            .alignmentGuide(.bottom) { _ in 0.5 }
        }
        .buttonStyle(PressEffectButtonStyle(theme: currentTheme, active: active, invertColors: button.action == .speak && button.pressedLabel == nil))
    }

    private func pressEffectButtonImage() -> String {
        if image != nil {
            return image ?? button.image
        }
        
        if button.pressedImage == nil {
            return button.image
        }
        
        if active && !isPressed {
            return button.image
        }
        
        if active && isPressed {
            return button.pressedImage ?? button.image
        }
        return button.image
    }

    private func getLabel() -> String {
        if isPressed && button.pressedLabel != nil {
            return button.pressedLabel!
        }
        return button.label
    }
}

struct PressEffectButtonStyle: ButtonStyle {
    var theme: Theme
    var background: Color?
    var active: Bool = false
    var invertColors: Bool = false
    
    init(theme: Theme, background: Color? = nil, active: Bool = false, invertColors: Bool = false) {
        self.background = background
        self.active = active
        self.invertColors = invertColors
        self.theme = theme
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(background ?? determineBackgroundColor(configuration: configuration))
//            .foregroundColor(determineForegroundColor(configuration: configuration))
            .overlay(
                configuration.label
                    .foregroundColor(determineForegroundColor(configuration: configuration)))
            .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
    }
    
    // .speak button should have inverted colors
    // .play button should have the "pressed" color while pause / play is in process
    // this is the only case as of now that uses self.active to determined the colors
    // all other buttons(including .speak) should be triggered through configuration.isPressed
    
    private func determineBackgroundColor(configuration: Configuration) -> Color {
        let isPressed = active || configuration.isPressed
        
        if invertColors {
            return isPressed ? theme.buttonDefaultColor : theme.buttonActiveColor
        } else {
            return isPressed ? theme.buttonActiveColor : theme.buttonDefaultColor
        }
    }

    private func determineForegroundColor(configuration: Configuration) -> Color {
        let isPressed = active || configuration.isPressed
        
        if invertColors {
            return isPressed ? theme.buttonActiveColor : theme.fontActiveColor
        } else {
            return isPressed ? theme.fontActiveColor : theme.buttonActiveColor
        }
    }
}
