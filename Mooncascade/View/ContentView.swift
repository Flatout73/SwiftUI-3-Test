//
//  ContentView.swift
//  Mooncascade
//
//  Created by Leonid Liadveikin on 24.07.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject
    var employeeFetcher: EmployeeFetcher

    @ObservedObject
    var contactStore: ContactStore

    @SectionedFetchRequest(
        sectionIdentifier: \Employee.position,
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Employee.position, ascending: true),
            NSSortDescriptor(keyPath: \Employee.lastName, ascending: true),
            NSSortDescriptor(keyPath: \Employee.name, ascending: true)
        ],
        animation: .default)
    var employees: SectionedFetchResults<String?, Employee>

    @State
    var isInitiallyFetched = false

    var body: some View {
        List {
            ForEach(employees) { sections in
                Section(sections.id ?? "NONE") {
                    ForEach(sections) { item in
                        EmployeeListView(employee: item, contactsStore: contactStore)
                    }
                }
            }
        }
        .refreshable(action: {
            do {
                try await employeeFetcher.parseAndFetchEmployees()
            } catch {
                assertionFailure("Server error: \(error.localizedDescription)")
            }
        })
            //.onDelete(perform: deleteItems)
        .toolbar {
            Button(action: clearCache) {
                Text("Clear cache")
            }
        }
        .task {
            guard !isInitiallyFetched else { return }
            do {
                try await employeeFetcher.parseAndFetchEmployees()
                isInitiallyFetched = true
            } catch {
                assertionFailure("Server error: \(error.localizedDescription)")
            }
        }
        .navigationTitle("Employees")
    }

    func clearCache() {
        employeeFetcher.clearCache()
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Employee(context: viewContext)
//            //newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { employeeFetcher.employees[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
