//
//  ContactPicker.swift
//  DeejayCalendar
//
//  Created by Divya Jain on 4/27/25.
//

import Foundation
import SwiftUI
import ContactsUI

struct ContactPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var onSelect: ([String]) -> Void

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        picker.predicateForEnablingContact = NSPredicate(format: "givenName.length > 0") // Optional filter
        return picker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        let parent: ContactPicker

        init(_ parent: ContactPicker) {
            self.parent = parent
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
            let names = contacts.map { "\($0.givenName) \($0.familyName)" }
            parent.onSelect(names)
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {}
    }
}


