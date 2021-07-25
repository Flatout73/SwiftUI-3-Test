//
//  ContactsView.swift
//  ContactsView
//
//  Created by Leonid Liadveikin on 25.07.2021.
//

import SwiftUI
import UIKit
import ContactsUI

struct ContactsView: UIViewControllerRepresentable {
    let contact: CNContact

    func makeUIViewController(context: Context) -> some UIViewController {
        let contactsVC = CNContactViewController(for: contact)
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Close"
        let button = UIButton(configuration: configuration, primaryAction: UIAction { _ in
            contactsVC.dismiss(animated: true, completion: nil)
        })
        contactsVC.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        return UINavigationController(rootViewController: contactsVC)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
