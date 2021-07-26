//
//  Persistence.swift
//  Mooncascade
//
//  Created by Leonid Liadveikin on 24.07.2021.
//

import CoreData

struct PersistenceController {

    // For tests
    #if DEBUG
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<10 {
            let newItem = Employee(context: viewContext)
            newItem.name = "Test"
            newItem.lastName = String(i)
        }
        do {
            try viewContext.save()
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return result
    }()
    #endif

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Mooncascade")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        } else {
            print("CoreDataURL:", container.persistentStoreDescriptions.first?.url ?? "")
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
