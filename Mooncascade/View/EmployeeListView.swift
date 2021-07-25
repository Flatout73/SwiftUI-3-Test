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
    var contactsStore: ContactStore

    @State
    var isContactsPresented = false

    @State
    var contact: CNContact?

    init(employee: Employee, contactsStore: ContactStore) {
        self.employee = employee
        self.contactsStore = contactsStore

        _contact = State(initialValue: contactsStore.contacts.first(where: {
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
        .onReceive(contactsStore.$contacts) { newContacts in
            if contact == nil {
                contact = newContacts.first(where: {
                    $0.givenName == employee.name &&
                    $0.familyName == employee.lastName
                })
            }
        }
    }
}
