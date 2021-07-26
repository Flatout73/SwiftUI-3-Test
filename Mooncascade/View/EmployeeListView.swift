//
//  EmployeeListView.swift
//  EmployeeListView
//
//  Created by Leonid Liadveikin on 24.07.2021.
//

import Foundation
import SwiftUI
import Contacts
import Combine

struct EmployeeListView: View {
    let employee: Employee

    @ObservedObject
    var contactStore: ContactStore

    @State
    var isContactsPresented = false

    @State
    var contact: CNContact?

    init(employee: Employee, contactStore: ContactStore) {
        self.employee = employee
        self.contactStore = contactStore

        _contact = State(initialValue: contactStore.contacts.first(where: {
            $0.givenName == employee.name &&
            $0.familyName == employee.lastName
        }))
    }

    var body: some View {
        NavigationLink(destination: EmployeeView(employee: employee, contact: contact)) {
            HStack {
                Text(employee.fullName)
                Spacer()
                if contact != nil {
                    Button(action: {
                        isContactsPresented = true
                    }, label: {
                        Image(systemName: "info.circle")
                            .accessibility(label: Text("Contact button"))
                    })
                        .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .sheet(isPresented: $isContactsPresented) {
            if let contact = contact {
                ContactsView(contact: contact)
            }
        }
        .onReceive(contactStore.$contacts) { newContacts in
            if contact == nil {
                contact = newContacts.first(where: {
                    $0.givenName == employee.name &&
                    $0.familyName == employee.lastName
                })
            }
        }
    }
}
