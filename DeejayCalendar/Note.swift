//
//  Note.swift
//  DeejayCalendar
//
//  Created by Divya Jain on 4/27/25.
//

import Foundation
import SwiftUI

struct Note: Identifiable, Codable {
    var id = UUID()
    var text: String
    let rotation: Double
    let colorName: String
    var date: Date
    var location: String?
    var participants: [String]
    
    
    var color: Color {
        switch colorName {
        case "yellow": return .yellow
        case "green": return .green
        case "pink": return .pink
        case "orange": return .orange
        case "blue": return .blue
        case "purple": return .purple
        default: return .yellow
        }
    }
    
    init(text: String) {
        self.text = text
        self.rotation = Double.random(in: -5...5)
        let colors = ["yellow", "green", "pink", "orange", "blue", "purple"]
        self.colorName = colors.randomElement() ?? "yellow"
        self.date = Date()
        self.location = nil
        self.participants = []
    }
    
    // This is needed for Codable to work
    init(text: String, rotation: Double, colorName: String, date: Date, location: String? = nil, participants: [String] = []) {
        self.text = text
        self.rotation = rotation
        self.colorName = colorName
        self.date = date
        self.location = location
        self.participants = participants
    }
}
