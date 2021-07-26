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
    var employeeStore: EmployeeStore

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

    @State
    var errorString: String? {
        didSet {
            isErrorShown = true
        }
    }

    @State
    var isErrorShown = false

    @State
    var searchText: String = ""

    private func mainView() -> some View {
        List {
            ForEach(employees) { sections in
                Section(sections.id ?? "NONE") {
                    if !searchText.isEmpty {
                        ForEach(sections.filter({ $0.fullName.contains(searchText) ||
                            $0.position?.contains(searchText) == true ||
                            $0.email?.contains(searchText) == true })) { item in
                            EmployeeListView(employee: item, contactsStore: contactStore)
                        }
                    } else {
                        ForEach(sections) { item in
                            EmployeeListView(employee: item, contactsStore: contactStore)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    var viewWithProgress: some View {
        if employeeStore.isLoading {
            mainView()
                .overlay(ProgressView())
        } else {
            mainView()
        }
    }

    var body: some View {
        viewWithProgress
        .searchable(text: $searchText)
        .refreshable(action: {
            do {
                try await employeeStore.parseAndFetchEmployees()
            } catch {
                errorString = error.localizedDescription
            }
        })
        .toolbar {
            Button(action: clearCache) {
                Text("Clear cache")
            }
        }
        .task {
            guard !isInitiallyFetched else { return }
            employeeStore.isLoading = true
            do {
                try await employeeStore.parseAndFetchEmployees()
                isInitiallyFetched = true
            } catch {
                errorString = error.localizedDescription
            }
            employeeStore.isLoading = false
        }
        .alert(errorString ?? "Error", isPresented: $isErrorShown) {
            Button("OK", role: .cancel) { }
        }
        .navigationTitle("Employees")
    }

    func clearCache() {
        employeeStore.clearCache()
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(employeeStore: EmployeeStore(persistence: PersistenceController.preview),
                    contactStore: ContactStore())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
