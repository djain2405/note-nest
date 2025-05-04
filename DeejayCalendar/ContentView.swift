//
//  ContentView.swift
//  DeejayCalendar
//
//  Created by Divya Jain on 4/26/25.
//

import SwiftUI


extension Date {
    func smartFormatted() -> String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(self) {
            return "Today"
        } else if calendar.isDateInYesterday(self) {
            return "Yesterday"
        } else if let daysAgo = calendar.dateComponents([.day], from: self, to: Date()).day,
                  daysAgo < 7 && daysAgo > 0 {
            return "\(daysAgo) days ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: self)
        }
    }
    
    func smartDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }

    func smartTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}

struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var newNote = ""
    @State private var selectedNote: Note?
    @State private var showEditSheet = false
    
    
    let today = Calendar.current.startOfDay(for: Date())

    var upcomingNotes: [Binding<Note>] {
        let today = Calendar.current.startOfDay(for: Date())
        return $notes.filter { $0.wrappedValue.date >= today }
                     .sorted { $0.wrappedValue.date < $1.wrappedValue.date }
    }

    var memoryNotes: [Binding<Note>] {
        let today = Calendar.current.startOfDay(for: Date())
        return $notes.filter { $0.wrappedValue.date < today }
                     .sorted { $0.wrappedValue.date < $1.wrappedValue.date }
    }

    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Enter a note", text: $newNote)
                        .textFieldStyle(.roundedBorder)
                    
                    Button(action: addNote) {
                        Image(systemName: "plus")
                            .padding()
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        if !upcomingNotes.isEmpty {
                            Text("Upcoming fun!")
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 20)], spacing: 20) {
                                ForEach(upcomingNotes) { $note in
                                    StickyNoteView(
                                        note: $note
                                    ) {
                                        deleteNote(note.id)
                                    }.onTapGesture {
                                        selectedNote = note
                                        showEditSheet = true
                                    }
                                }
                            }
                            .padding()
                        }
                        if !memoryNotes.isEmpty {
                            Text("Memories")
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                                ForEach(memoryNotes) { $note in
                                    StickyNoteView(note: $note) {
                                        deleteNote(note.id)
                                    }
                                    .onTapGesture {
                                        selectedNote = note
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
            .navigationTitle("My excitements!")
            .onAppear(perform: loadNotes)
            .sheet(item: $selectedNote) { note in
                EditNoteView(note: binding(for: note)) {
                    saveNotes()
                }
            }
        }
    }

    func binding(for note: Note) -> Binding<Note> {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else {
            fatalError("Can't find note!")
        }
        return $notes[index]
    }
    
    func addNote() {
        guard !newNote.isEmpty else { return }
        let note = Note(text: newNote)
        notes.append(note)
        newNote = ""
        saveNotes()
    }
    
    func deleteNote(_ id: UUID) {
        if let index = notes.firstIndex(where: { $0.id == id }) {
            notes.remove(at: index)
            saveNotes()
        }
    }
    
    func saveNotes() {
        if let encoded = try? JSONEncoder().encode(notes) {
            UserDefaults.standard.set(encoded, forKey: "notes")
        }
    }
    
    func loadNotes() {
        if let savedData = UserDefaults.standard.data(forKey: "notes"),
           let decoded = try? JSONDecoder().decode([Note].self, from: savedData) {
            notes = decoded
        }
    }
}


#Preview {
    ContentView()
}
