//
//  EmployeeListView.swift
//  EmployeeListView
//
//  Created by Leonid Liadveikin on 24.07.2021.
//

import Foundation
import SwiftUI

struct EmployeeListView: View {
    let employee: Employee

    @ObservedObject
    var contactsStore: ContactStore

    @State
    var isContactsPresented = false

    var body: some View {
        NavigationLink(destination: EmployeeView(employee: employee)) {
            HStack {
                Text(employee.fullName)
                Spacer()
                if contactsStore.contacts
                    .contains(where: { $0.givenName == employee.name &&
                        $0.familyName == employee.lastName }) {
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
            if let contact = contactsStore.contacts
                .first(where: { $0.givenName == employee.name &&
                    $0.familyName == employee.lastName }) {
                ContactsView(contact: contact)
            }
        }
    }
}
