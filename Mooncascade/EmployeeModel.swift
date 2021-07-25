//
//  EmployeeModel.swift
//  EmployeeModel
//
//  Created by Leonid Liadveikin on 24.07.2021.
//

import Foundation

struct Employees: Codable {
    let employees: [EmployeeModel]
}

struct EmployeeModel: Codable {
    struct ContactDetails: Codable {
        let email: String?
        let phone: String?
    }
    let fname: String
    let lname: String
    let position: String
    let contactDetails: ContactDetails
    let projects: [String]?
}
