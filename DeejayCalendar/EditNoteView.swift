//
//  EditNoteView.swift
//  DeejayCalendar
//
//  Created by Divya Jain on 4/27/25.
//

import Foundation
import SwiftUI

struct EditNoteView: View {
    @Binding var note: Note
    var onSave: () -> Void
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showContactPicker = false

    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TextField("Edit text...", text: $note.text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Pick a Date 📅")
                        .font(.headline)

                    DatePicker("", selection: $note.date, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                }
                .padding()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Pick a Time ⏰")
                        .font(.headline)

                    DatePicker("", selection: $note.date, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }
                .padding()
                
                Button("Add Participant 👥") {
                    showContactPicker = true
                }
                .sheet(isPresented: $showContactPicker) {
                    ContactPicker { selectedNames in
                        note.participants.append(contentsOf: selectedNames)
                    }
                }
                .padding()
                
                if !note.participants.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Participants:")
                            .font(.headline)

                        ForEach(note.participants, id: \.self) { participant in
                            Text("👤 \(participant)")
                                .font(.subheadline)
                        }
                    }
                    .padding()
                }

                
                Button("Save") {
                    onSave()
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

