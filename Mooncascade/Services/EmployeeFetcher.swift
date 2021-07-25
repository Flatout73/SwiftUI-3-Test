//
//  EmployeeFetcher.swift
//  EmployeeFetcher
//
//  Created by Leonid Liadveikin on 24.07.2021.
//

import SwiftUI
import Combine
import CoreData

class EmployeeFetcher: ObservableObject {
    lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    let persistence: PersistenceController

    init(persistence: PersistenceController) {
        self.persistence = persistence
    }

    func parseAndFetchEmployees() async throws {
        let employees = try await fetchEmployees()
        try await persistence.container.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            _ = employees.employees.map { newEmployee in
                let coreDataEmployee = self.findInCoreData(by: newEmployee.fname, lastName: newEmployee.lname,
                                                      in: context) ?? Employee(context: context)
                coreDataEmployee.name = newEmployee.fname
                coreDataEmployee.lastName = newEmployee.lname
                coreDataEmployee.position = newEmployee.position
                coreDataEmployee.phone = newEmployee.contactDetails.phone
                coreDataEmployee.email = newEmployee.contactDetails.email
                // TODO: Parse other properties
            }

            try context.save()
        }
    }

    func findInCoreData(by name: String, lastName: String, in context: NSManagedObjectContext) -> Employee? {
        let fetchRequest = Employee.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(#keyPath(Employee.name)) == %@ && \(#keyPath(Employee.lastName)) == %@", name, lastName)
        return try? context.fetch(fetchRequest).first
    }

    func clearCache() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Employee.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        persistence.container.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            do {
                if let result = try context.execute(deleteRequest) as? NSBatchDeleteResult {
                    let objectIDArray = result.result as? [NSManagedObjectID]
                    let changes = [NSDeletedObjectsKey: objectIDArray]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes,
                                                        into: [context, self.persistence.container.viewContext])
                }
                try context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
        objectWillChange.send()
    }

    private func fetchEmployees() async throws -> Employees {
        do {
            let url = URL(string: "https://tallinn-jobapp.aw.ee/employee_list/")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let employees = try jsonDecoder.decode(Employees.self, from: data)
            return employees
        } catch {
            throw EmployeeError.serverError
        }
    }
}
