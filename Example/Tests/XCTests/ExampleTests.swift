//
//  ExampleTests.swift
//  Mocky_Tests
//
//  Created by Andrzej Michnia on 25.10.2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
import Mocky
@testable import Mocky_Example

class ExampleTests: XCTestCase {
    func testGivenExample() {
        let mock = UserStorageTypeMock()

        Given(mock, .surname(for: .value("Johny"), willReturn: "Bravo"))
        Given(mock, .surname(for: .any(String.self), willReturn: "Kowalsky"))

        XCTAssertEqual(mock.surname(for: "Johny"), "Bravo")
        XCTAssertEqual(mock.surname(for: "Mathew"), "Kowalsky")
        XCTAssertEqual(mock.surname(for: "Joanna"), "Kowalsky")
    }

    func testVerifyExample() {
        let sut = UsersViewModel()
        let mockStorage = UserStorageTypeMock()

        // inject mock to sut. Every time sut saves user data, it should trigger storage storeUser method
        sut.usersStorage = mockStorage
        sut.saveUser(name: "Johny", surname: "Bravo")
        sut.saveUser(name: "Johny", surname: "Cage")
        sut.saveUser(name: "Jon", surname: "Snow")

        // check is Jon Snow was stored at least one time
        Verify(mockStorage, .storeUser(name: .value("Jon"), surname: .value("Snow")))
        // total storeUser should be triggered 3 times, regardless of attributes values
        Verify(mockStorage, 3, .storeUser(name: .any(String.self), surname: .any(String.self)))
        // two times it should be triggered with name Johny
        Verify(mockStorage, 2, .storeUser(name: .value("Johny"), surname: .any(String.self)))
    }
}
