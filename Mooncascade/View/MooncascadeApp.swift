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
    var employeeFetcher = EmployeeFetcher(persistence: PersistenceController.shared)

    @StateObject
    var contactStore = ContactStore()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(employeeFetcher: employeeFetcher, contactStore: contactStore)
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            }
        }
    }
}
