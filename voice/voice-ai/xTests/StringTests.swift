@testable import Voice_AI
import XCTest

class StringExtensionsTests: XCTestCase {
    func testRangesOfString() {
        let inputString = "Hello, world! This is a test. Hello, world again."
        let substring = "Hello"

        let ranges = inputString.ranges(of: substring)

        XCTAssertEqual(ranges.count, 2, "Should find 2 occurrences of 'Hello'")
        XCTAssertEqual(inputString[ranges[0]], "Hello", "First occurrence should match 'Hello'")
        XCTAssertEqual(inputString[ranges[1]], "Hello", "Second occurrence should match 'Hello'")
    }

//    func testRangesOfStringWithOptions() {
//        let inputString = "Swift is a powerful and fast language. Swiftness is a key factor."
//        let substring = "swift"
//
//        let ranges = inputString.ranges(of: substring, options: .caseInsensitive)
//
//        XCTAssertEqual(ranges.count, 2, "Should find 2 occurrences of 'swift' (case-insensitive)")
//        XCTAssertEqual(inputString[ranges[0]], "Swift", "First occurrence should match 'Swift'")
//        XCTAssertEqual(inputString[ranges[1]], "Swiftness", "Second occurrence should match 'Swiftness'")
//    }

//    func testRangesOfStringWithLocale() {
//        let inputString = "Café is a French word. Cafe is an English word."
//        let substring = "cafe"
//        let locale = Locale(identifier: "en_US")
//
//        let ranges = inputString.ranges(of: substring, locale: locale)
//
//        XCTAssertEqual(ranges.count, 1, "Should find 1 occurrence of 'cafe' with English locale")
//        XCTAssertEqual(inputString[ranges[0]], "Cafe", "First occurrence should match 'Cafe'")
//    }

    func testRangesOfStringNotFound() {
        let inputString = "This is a test string."
        let substring = "apple"

        let ranges = inputString.ranges(of: substring)

        XCTAssertTrue(ranges.isEmpty, "Should not find any occurrences of 'apple'")
    }
}
