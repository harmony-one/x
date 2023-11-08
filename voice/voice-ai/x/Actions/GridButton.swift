import Foundation
import SwiftUI

struct GridButton: View {
    var currentTheme:Theme
    var button: ButtonData
    var foregroundColor: Color
    var active: Bool = false;
    var isPressed: Bool = false
    var image: String? = nil;
    var colorExternalManage: Bool = false;
    var action: () -> Void
    let buttonSize: CGFloat = 100
    let imageTextSpacing: CGFloat = 40
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    var body: some View {
        Button(action: {
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
//                    .foregroundColor(COLOR_ACTIVE)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(0)
            .alignmentGuide(.bottom) { _ in 0.5 }
        }
        .buttonStyle(PressEffectButtonStyle(theme: currentTheme, active: active, invertColors: button.action == .speak))
    }

    private func pressEffectButtonImage() -> String {
        if (self.image != nil) {
            return self.image ?? button.image
        }
        
        if (button.pressedImage == nil) {
            return button.image
        }
        
        if (self.active && !isPressed) {
            return button.image
        }
        
        if (self.active && isPressed) {
            return button.pressedImage ?? button.image
        }
        return button.image
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
        let isPressed =  self.active || configuration.isPressed
        
        if invertColors {
            return isPressed ? self.theme.buttonDefaultColor : self.theme.buttonActiveColor
        } else {
            return isPressed ? self.theme.buttonActiveColor : self.theme.buttonDefaultColor
        }
    }

    private func determineForegroundColor(configuration: Configuration) -> Color {
        let isPressed =  self.active || configuration.isPressed
        
        if invertColors {
            return isPressed ? self.theme.buttonActiveColor : self.theme.fontActiveColor
        } else {
            return isPressed ? self.theme.fontActiveColor : self.theme.buttonActiveColor
        }
    }
}
