    //
    //  ContentView.swift
    //  AudioPlayer
    //
    //  Created by Nathan Christensen on 2024-02-21.
    //

    import SwiftUI
    import SwiftData
    import AVFoundation

    struct ContentView: View {
        @Environment(\.modelContext) private var modelContext
        @Query private var items: [Item]
        
        var audioManager = AudioManager()
        
        @State private var pickedFileURL: URL?
        @State private var selectedTime = Date()
        
        var body: some View {
            VStack {
                if let pickedFileURL = pickedFileURL {
                    Text("Picked file: \(pickedFileURL.lastPathComponent)")
                    DatePicker("Pick a time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .datePickerStyle(WheelDatePickerStyle())
                    Text("Selected Time: \(selectedTime.timeIntervalSinceNow)")
                                    .padding()
                    Button("Play Audio") {
                                        audioManager.loadAudio(from: pickedFileURL)
                                        audioManager.playAudio(for: 15) // Play for 1 minute before volume starts to lower
                                    }
                    
                } else {
                    Text("No file picked")
                    Button("Pick MP3 File") {
                                        presentDocumentPicker()
                                    }
                }
            }
        }
        
        private func presentDocumentPicker() {
            let picker = DocumentPicker { url in
                self.pickedFileURL = url
            }
            
            // This is necessary to present the picker in SwiftUI
            if let rootVC = UIApplication.shared.windows.first?.rootViewController {
                let vc = UIHostingController(rootView: picker)
                vc.modalPresentationStyle = .fullScreen
                rootVC.present(vc, animated: true, completion: nil)
            }
        }
        
    //    private func saveCurrent() {
    //        modelContext.insert(items.first)
    //    }
    }

    #Preview {
        ContentView()
            .modelContainer(for: Item.self, inMemory: true)
    }
