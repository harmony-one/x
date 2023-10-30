//
//  xTests.swift
//  xTests
//
//  Created by Aaron Li on 10/13/23.
//

import XCTest
@testable import Hey_Artem

final class PaymentsTests: XCTestCase {
    var checkoutModel: StripeCheckoutModel!

    override func setUpWithError() throws {
        checkoutModel = StripeCheckoutModel()
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
        XCTAssertFalse(checkoutModel.isPaid)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
