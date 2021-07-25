//
//  EmployeeError.swift
//  EmployeeError
//
//  Created by Leonid Liadveikin on 24.07.2021.
//

import Foundation

enum EmployeeError: LocalizedError {
    case serverError

    var errorDescription: String? {
        return "Error of getting data"
    }
}
