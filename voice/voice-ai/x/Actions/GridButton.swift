import Foundation
import SwiftUI

struct GridButton: View {
    
    @ObservedObject var currentTheme:Theme
    
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
        .buttonStyle(PressEffectButtonStyle(theme: currentTheme, active: active, invertColors: button.action == .speak))
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
                .foregroundColor(determineForegroundColor(configuration: configuration))
                .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
        }
    
    // .speak button should have inverted colors
    // .play button should have the "pressed" color while pause / play is in process
    // this is the only case as of now that uses self.active to determined the colors
    // all other buttons(including .speak) should be triggered through configuration.isPressed
    
    private func determineBackgroundColor(configuration: Configuration) -> Color {
        print("^^^^^^^")
        print(self.theme.buttonActiveColor)
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
            return isPressed ? self.theme.buttonActiveColor : self.theme.buttonDefaultColor
        } else {
            return isPressed ? self.theme.buttonDefaultColor : self.theme.buttonActiveColor
        }
    }
}
