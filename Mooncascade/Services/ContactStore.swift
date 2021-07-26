//
//  ContactStore.swift
//  ContactStore
//
//  Created by Leonid Liadveikin on 25.07.2021.
//

import Combine
import Contacts
import ContactsUI

final class ContactStore: ObservableObject {
    private let store = CNContactStore()

    private let keysToFetch: [CNKeyDescriptor] = [
        CNContactGivenNameKey as CNKeyDescriptor,
        CNContactFamilyNameKey as CNKeyDescriptor,
        CNContactViewController.descriptorForRequiredKeys()
    ]

    private lazy var allContainers = try? store.containers(matching: nil)
    private let queue = DispatchQueue(label: "mooncascade.com-contacts")

    @Published
    var contacts: [CNContact] = []

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
                    if !containerResults.isEmpty {
                        DispatchQueue.main.async {
                            self.contacts.append(contentsOf: containerResults)
                        }
                    }
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
