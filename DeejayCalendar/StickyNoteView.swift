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
        VStack(alignment: .leading, spacing: 10) {
            // Top: Note Text
            Text(note.text)
                .font(.headline)
                .bold()
                .multilineTextAlignment(.leading)
                .lineLimit(4) // Allow unlimited lines
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 5)
                .padding([.horizontal], 10)
                .foregroundColor(.black)
            
            Spacer()
            
            // Middle: Date and Time
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Image(systemName: "calendar")
                    Text(note.date.smartDate())
                }
                .font(.caption)
                .foregroundColor(.black.opacity(0.7))
                
                HStack {
                    Image(systemName: "clock")
                    Text(note.date.smartTime())
                }
                .font(.caption2)
                .foregroundColor(.black.opacity(0.6))
            }
            .padding(5)
            .background(Color.white.opacity(0.4))
            .cornerRadius(8)
            
            // Middle: Location (if available)
            if let location = note.location, !location.isEmpty {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text(location)
                }
                .font(.caption2)
                .foregroundColor(.black.opacity(0.6))
                .padding(5)
                .background(Color.white.opacity(0.4))
                .cornerRadius(8)
            }
            
            // Bottom: Participants (if any)
            if !note.participants.isEmpty {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Participants:")
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.black.opacity(0.8))
                    
                    ForEach(note.participants.prefix(2), id: \.self) { participant in
                        HStack {
                            Image(systemName: "person.crop.circle")
                            Text(participant)
                        }
                        .font(.caption2)
                        .foregroundColor(.black.opacity(0.6))
                    }
                }
                .padding(5)
                .background(Color.white.opacity(0.4))
                .cornerRadius(8)
            }
        }
        .padding()
        .fixedSize(horizontal: false, vertical: true)
        .background(note.color)
        .cornerRadius(18)
        .shadow(radius: 5)
        .rotationEffect(.degrees(note.rotation))
        .onLongPressGesture {
            onDelete()
        }
    }
}

