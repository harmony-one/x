import XCTest
import SwiftUI
@testable import Voice_AI

class Theme {
    var primaryColor: Color
    var secondaryColor: Color

    init(primaryColor: Color, secondaryColor: Color) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }
}

struct ButtonData {
    var image: String
    var pressedImage: String?
    var label: String
    var pressedLabel: String?
    var action: ActionType // Assuming ActionType is an enum or similar

    init(image: String, pressedImage: String?, label: String, pressedLabel: String?, action: ActionType) {
        self.image = image
        self.pressedImage = pressedImage
        self.label = label
        self.pressedLabel = pressedLabel
        self.action = action
    }
}

class GridButtonTests: XCTestCase {

    var theme: Theme!
    var buttonData: ButtonData!
    var actionTriggered: EventType?

    override func setUp() {
        super.setUp()
        // Initialize common variables for the tests
        theme = Theme(primaryColor: .blue, secondaryColor: .gray)
        buttonData = ButtonData(image: "buttonImage",
                                pressedImage: "buttonPressedImage",
                                label: "Button",
                                pressedLabel: "Button Pressed",
                                action: .speak)
    }

    func testOnDragStartAndEnd() {
        let gridButton = GridButton(currentTheme: theme, button: buttonData, foregroundColor: .red, action: { eventType in
            self.actionTriggered = eventType
        })

        XCTAssertNil(actionTriggered)

        gridButton.onDragStart()
        XCTAssertEqual(actionTriggered, .onStart)

        gridButton.onDragEnded()
        XCTAssertEqual(actionTriggered, .onEnd)
    }

    override func tearDown() {
        theme = nil
        buttonData = nil
        actionTriggered = nil
        super.tearDown()
    }
}
