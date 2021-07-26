//
//  EmployeeView.swift
//  EmployeeView
//
//  Created by Leonid Liadveikin on 25.07.2021.
//

import SwiftUI
import Contacts

struct EmployeeView: View {
    let employee: Employee
    let contact: CNContact?

    @State
    var isContactsViewPresented = false

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            List {
                if let position = employee.position {
                    employeeInfoView(title: "Position", value: position)
                }
                if let email = employee.email {
                    employeeInfoView(title: "Email", value: email, link: URL(string: "mailto:\(email)"))
                }
                if let phone = employee.phone {
                    employeeInfoView(title: "Phone", value: phone, link: URL(string: "tel:\(phone)"))
                }
                if let projects = employee.projects?.allObjects as? [Project] {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Projects")
                            .font(.headline)
                        VStack(alignment: .leading) {
                            ForEach(projects) { project in
                                if let name = project.name {
                                    Text(name)
                                }
                            }
                        }
                    }
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            if contact != nil {
                Button("Contact") {
                    isContactsViewPresented = true
                }
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: 44, alignment: .center)
                .background(Color.black)
                .cornerRadius(8)
                .padding()
                .background(Color(uiColor: UIColor.systemGroupedBackground))
            }
        }
        .navigationTitle(employee.fullName)
        .sheet(isPresented: $isContactsViewPresented) {
            if let contact = contact {
                ContactsView(contact: contact)
            }
        }
    }

    func employeeInfoView(title: String, value: String, link: URL? = nil) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            if let link = link {
                Link(value, destination: link)
                    .multilineTextAlignment(.leading)
            } else {
                Text(value)
            }
        }
    }
}
