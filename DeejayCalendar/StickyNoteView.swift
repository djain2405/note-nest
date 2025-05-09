//
//  StickyNoteView.swift
//  DeejayCalendar
//
//  Created by Divya Jain on 4/27/25.
//

import Foundation
import SwiftUI

struct StickyNoteView: View {
    @Binding var note: Note
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title
            Text(note.text)
                .font(.title3)
                .bold()
                .padding(.bottom, 4)
                .lineLimit(nil) // ← allow full wrapping
                .fixedSize(horizontal: false, vertical: true)

            // Participants
            if !note.participants.isEmpty {
                Text("👥 " + note.participants.prefix(3).joined(separator: ", "))
                    .font(.subheadline)
            }

            // Location
            if let location = note.location, !location.isEmpty {
                Text("📍 \(location)")
                    .font(.subheadline)
            }

            Spacer()

            // Date & Time
            HStack {
                Text("🗓 \(note.date.smartDate())")
                Spacer()
                Text("⏰ \(note.date.smartTime())")
            }
            .font(.caption)
            .padding(.top, 6)
        }
        .padding()
        .frame(width: 180)
        .frame(minHeight: 200)
        .background(note.color)
        .cornerRadius(16)
        .shadow(radius: 5)
    }
}

