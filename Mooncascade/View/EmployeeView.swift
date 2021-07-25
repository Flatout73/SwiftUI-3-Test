//
//  EmployeeView.swift
//  EmployeeView
//
//  Created by Leonid Liadveikin on 25.07.2021.
//

import SwiftUI

struct EmployeeView: View {
    let employee: Employee

    var body: some View {
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
            if let projects = employee.projects {
                Text("projects")
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .navigationTitle(employee.fullName)
    }

    func employeeInfoView(title: String, value: String, link: URL? = nil) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            if let link = link {
                Link(value, destination: link)
            } else {
                Text(value)
            }
        }
    }
}
