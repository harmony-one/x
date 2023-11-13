import XCTest

class PersistenceTests: XCTestCase {

    func testIncreaseConsumablesCount() {
        // Given
        let initialCreditsCount = UserDefaults.standard.integer(forKey: Persistence.creditsCountKey)
        let creditsAmount = 5

        // When
        Persistence.increaseConsumablesCount(creditsAmount: creditsAmount)

        // Then
        let updatedCreditsCount = UserDefaults.standard.integer(forKey: Persistence.creditsCountKey)
        XCTAssertEqual(updatedCreditsCount, initialCreditsCount + creditsAmount)
    }

    // Add more test cases as needed

}
