//
//  ContentView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 14/06/2022.
//

import SwiftUI

struct ContentView: View {
    
    var repositories = ["Repository 1", "Repository 2"]
    @State private var selectedRepositoryIndex = 0
    @State private var catelogueRefernce = ""
    @State private var item = 0
    @State private var subItem = 0
    @State private var specialCase = 0
    @State private var note = ""
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Picker(selection: $selectedRepositoryIndex, label: Text("Repository")) {
                        ForEach(0 ..< repositories.count) {
                            Text(self.repositories[$0])
                        }
                    }
        
                    TextField("Catalogue reference", text: $catelogueRefernce)
                    Stepper(value: $item, in: 0...999) {
                        Text("Item: \(item)")
                    }
                    Stepper(value: $subItem, in: 0...999) {
                        Text("Sub Item: \(subItem)")
                    }
                    Stepper(value: $specialCase, in: 0...999) {
                        Text("Special Case: \(specialCase)")
                    }
                    TextField("Note", text: $note)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
