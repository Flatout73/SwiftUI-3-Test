//
//  MooncascadeApp.swift
//  Mooncascade
//
//  Created by Leonid Liadveikin on 24.07.2021.
//

import SwiftUI

@main
struct MooncascadeApp: App {
    @StateObject
    var employeeFetcher = EmployeeStore(persistence: PersistenceController())

    @StateObject
    var contactStore = ContactStore()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(employeeStore: employeeFetcher, contactStore: contactStore)
                    .environment(\.managedObjectContext, employeeFetcher.persistence.container.viewContext)
            }
        }
    }
}
