//
//  MooncascadeTests.swift
//  MooncascadeTests
//
//  Created by Leonid Liadveikin on 24.07.2021.
//

import XCTest
@testable import Mooncascade
import CoreData
import Combine

class MooncascadeTests: XCTestCase {

    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        cancellable = nil
    }

    func testEmployee() async throws {
        let persistence = PersistenceController.preview
        let employeeStore = EmployeeStore(persistence: persistence)
        try await employeeStore.parseAndFetchEmployees()

        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        let employees = try persistence.container.viewContext.fetch(fetchRequest)
        XCTAssertTrue(employees.count > 10)
    }

    var cancellable: AnyCancellable?
    func testContacts() {
        let expectation = XCTestExpectation(description: "Get contacts")

        let contactStore = ContactStore()
        cancellable = contactStore.$contacts.sink(receiveValue: { contacts in
            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
