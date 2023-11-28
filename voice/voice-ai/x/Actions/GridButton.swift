import Foundation
import SwiftUI

enum EventType {
    case onStart
    case onEnd
}

struct GridButton: View {
    var currentTheme: Theme
    var button: ButtonData
    var foregroundColor: Color
    var active: Bool = false
    var isPressed: Bool = false
    var clickCounterStartOn = 100
    var isButtonEnabled: Bool = true
    @State private var timeAtPress = Date()
    @State private var isDragActive = false

    var image: String?
    var colorExternalManage: Bool = false
    var action: (_ event: EventType?) -> Void
    
    let buttonSize: CGFloat = 100
    let imageTextSpacing: CGFloat = 40
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var debounceTimer: Timer?
    @State private var clickCounter = 0

    func onDragEnded() {
        isDragActive = false
        
        action(.onEnd)
    }

    func onDragStart() {
        if !isDragActive {
            isDragActive = true

            timeAtPress = Date()
        }
        
        action(.onStart)
    }

    var body: some View {
        let drag = DragGesture(minimumDistance: 0)
            .onChanged { _ in
                self.onDragStart()
            }
            .onEnded { _ in
                self.onDragEnded()
            }

        let hackyPinch = MagnificationGesture(minimumScaleDelta: 0.0)
            .onChanged { _ in
                self.onDragEnded()
            }
            .onEnded { _ in
                self.onDragEnded()
            }

        let hackyRotation = RotationGesture(minimumAngleDelta: Angle(degrees: 0.0))
            .onChanged { _ in
                self.onDragEnded()
            }
            .onEnded { _ in
                self.onDragEnded()
            }

        let hackyPress = LongPressGesture(minimumDuration: 0.0, maximumDistance: 0.0)
            .onChanged { _ in
                self.onDragEnded()
            }
            .onEnded { _ in
                self.onDragEnded()
            }

        let combinedGesture = drag
            .simultaneously(with: hackyPinch)
            .simultaneously(with: hackyRotation)
            .exclusively(before: hackyPress)

        Button(action: {
            if self.isButtonEnabled {
                let elapsed = Date().timeIntervalSince(self.timeAtPress)
                
                if elapsed < 1.5 {
                    self.clickCounter += 1
                    
                    Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                        self.clickCounter -= 1
                    }
                    
                    self.debounceTimer?.invalidate()
                    
                    // print("self.clickCounter", self.clickCounter)
                    
                    if self.clickCounter >= self.clickCounterStartOn {
                        self.debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                            action(nil)
                        }
                    } else {
                        action(nil)
                    }
                }
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
        .buttonStyle(PressEffectButtonStyle(theme: currentTheme, active: active, invertColors: button.action == .speak && button.pressedLabel == nil, isButtonEnabled: self.isButtonEnabled))
        .simultaneousGesture(combinedGesture)
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
    var isButtonEnabled: Bool = true
    
    init(theme: Theme, background: Color? = nil, active: Bool = false, invertColors: Bool = false, isButtonEnabled: Bool = true) {
        self.background = background
        self.active = active
        self.invertColors = invertColors
        self.theme = theme
        self.isButtonEnabled = isButtonEnabled
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(background ?? determineBackgroundColor(configuration: configuration))
//            .foregroundColor(determineForegroundColor(configuration: configuration))
            .overlay(
                configuration.label
                    .foregroundColor(determineForegroundColor(configuration: configuration)))
            .animation(.easeInOut(duration: 0.08), value: configuration.isPressed)
            .opacity(isButtonEnabled ? 1.0 : 1.0) // 0.3
    }

    // .speak button should have inverted colors
    // .play button should have the "pressed" color while pause / play is in process
    // this is the only case as of now that uses self.active to determined the colors
    // all other buttons(including .speak) should be triggered through configuration.isPressed

    func determineBackgroundColor(configuration: Configuration) -> Color {
        // Below logic causing colorway to switch
//        let isPressed = active || ((configuration?.isPressed) != nil)
        let isPressed = active || configuration.isPressed

        if invertColors {
            return isPressed ? theme.buttonDefaultColor : theme.buttonActiveColor
        } else {
            return isPressed ? theme.buttonActiveColor : theme.buttonDefaultColor
        }
    }

    func determineForegroundColor(configuration: Configuration) -> Color {
        // Below logic causing colorway to switch
//        let isPressed = active || ((configuration?.isPressed) != nil)
        let isPressed = active || configuration.isPressed
<<<<<<< HEAD

=======
>>>>>>> 7bfbc87 (progress + fix)
        
        if invertColors {
            return isPressed ? theme.buttonActiveColor : theme.fontActiveColor
        } else {
            return isPressed ? theme.fontActiveColor : theme.buttonActiveColor
        }
    }
}
