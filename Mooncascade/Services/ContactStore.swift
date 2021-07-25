//
//  ContactStore.swift
//  ContactStore
//
//  Created by Leonid Liadveikin on 25.07.2021.
//

import Combine
import Contacts
import ContactsUI

class ContactStore: ObservableObject {
    let store = CNContactStore()

    let keysToFetch: [CNKeyDescriptor] = [
        CNContactGivenNameKey as CNKeyDescriptor,
        CNContactFamilyNameKey as CNKeyDescriptor,
        CNContactViewController.descriptorForRequiredKeys()
    ]

    lazy var allContainers = try? store.containers(matching: nil)

    @Published
    var contacts: [CNContact] = []

    let queue = DispatchQueue(label: "mooncascade.com-contacts")

    init() {
        fetchContacts()
    }

    func fetchContacts() {
        queue.async { [weak self] in
            guard let self = self else { return }
            do {
                for container in self.allContainers ?? [] {
                    let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                    let containerResults = try self.store.unifiedContacts(matching: fetchPredicate,
                                                                          keysToFetch: self.keysToFetch)
                    DispatchQueue.main.async {
                        self.contacts.append(contentsOf: containerResults)
                    }
                }
                //            let contacts = try store.unifiedContacts(matching: NSPredicate(), keysToFetch: keysToFetch)
                //            self.contacts = contacts
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
