//
//  Employee+Name.swift
//  Employee+Name
//
//  Created by Leonid Liadveikin on 25.07.2021.
//

import Foundation

extension Employee {
    public var id: String { fullName }

    var fullName: String {
        let nameString = "\(name ?? "") \(lastName ?? "")"
        do {
            let components = try PersonNameComponents(nameString)
            return nameFormatter.string(from: components)
        } catch {
            return nameString
        }
    }
}
