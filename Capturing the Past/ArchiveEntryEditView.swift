//
//  ContentView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 14/06/2022.
//

import SwiftUI

/**
 * View for viewing and editing an archive entry
 */
struct ArchiveEntryEditView: View {
    @Binding var data: ArchiveEntry.Data
    @State var showPicker = false
    @State var image: UIImage?
    @State var source: ImagePicker.Source = .library

    @State var showCameraAlert = false
    @State var imageName: String = ""
    @State var isEditing = false
    @State var selectedImage: Photo?
    @State var showFileAlert = false
    @State var appError: CapturingThePastError.ErrorType?

    var repositories = ["Repository 1", "Repository 2"]

    func showPhotoPicker() {
        do {
            if source == .camera {
                try ImagePicker.checkPermissions()
            }
            showPicker = true
        } catch {
            showCameraAlert = true
            appError = CapturingThePastError.ErrorType(error: error as! CapturingThePastError)
        }
    }

    var pickerButtons: some View {
        HStack {
            Button {
                source = .camera
                showPhotoPicker()
            } label: {
                ButtonLabel(symbolName: "camera", label: "Camera")
            }
            .alert("Error", isPresented: $showCameraAlert, presenting: appError, actions: { cameraError in
                cameraError.button
            }, message: { cameraError in
                Text(cameraError.message)
            })
            Button {
                source = .library
                showPhotoPicker()
            } label: {
                ButtonLabel(symbolName: "photo", label: "Photos")
            }
        }
    }

    var imageScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(data.photos) { photo in
                    VStack {
                        Image(uiImage: photo.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
                        Text(photo.id)
                    }
                }
            }
        }.padding(.horizontal)
    }

    var dataFields: some View {
        VStack {
            /*
             Picker(selection: $selectedRepositoryIndex, label: Text("Repository")) {
             ForEach(0 ..< repositories.count) {
             Text(self.repositories[$0])
             }
             }
             */
            TextField("Catalogue reference", text: $data.catReference)
            Spacer()
            Stepper(value: $data.item, in: 0...999) {
                Text("Item: \(data.item)")
            }
            Stepper(value: $data.subItem, in: 0...999) {
                Text("Sub Item: \(data.subItem)")
            }
            Spacer()
            /*
             Stepper(value: $archiveEntry.specialCase, in: 0...999) {
             Text("Special Case: \($archiveEntry.specialCase)")
             }
             */
            TextField("Note", text: $data.note)
        }
    }

    func didDismissImagePicker() {
        // Handle the dismissing action.
    }

    var body: some View {
        VStack {
            Form {
                dataFields
            }
            pickerButtons
            Spacer()
            imageScroll
        }
        .sheet(isPresented: $showPicker, onDismiss: didDismissImagePicker) {
            if image == nil {
                ImagePicker(sourceType: source == .library ? .photoLibrary : .camera, selectedImage: $image)
                    .ignoresSafeArea()
            } else {
                VStack {
                    Text("Enter image name")
                    TextField("Image name", text: $imageName)
                    Divider()
                    HStack {
                        Button(action: {
                            data.photos.append(Photo(id: imageName))
                            image = nil
                            showPicker = false

                        }) {
                            Text("Ok")
                        }
                    }
                }
            }
        }
    }
}

struct ArchiveEntryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArchiveEntryEditView(data: .constant(ArchiveEntry.sampleEntries[0].data))
        }
    }
}
