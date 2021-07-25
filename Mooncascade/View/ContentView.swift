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
        return List {
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

    var body: some View {
        ZStack {
            mainView()

            if employeeFetcher.isLoading {
                ProgressView()
            }
        }
        .searchable(text: $searchText)
        .refreshable(action: {
            do {
                try await employeeFetcher.parseAndFetchEmployees()
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
            employeeFetcher.isLoading = true
            do {
                try await employeeFetcher.parseAndFetchEmployees()
                isInitiallyFetched = true
            } catch {
                errorString = error.localizedDescription
            }
            employeeFetcher.isLoading = false
        }
        .alert(errorString ?? "Error", isPresented: $isErrorShown) {
            Button("OK", role: .cancel) { }
        }
        .navigationTitle("Employees")
    }

    func clearCache() {
        employeeFetcher.clearCache()
    }
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
