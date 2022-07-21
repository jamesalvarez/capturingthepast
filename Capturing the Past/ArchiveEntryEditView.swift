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
    @Binding var repositories: [Repository]
    @Binding var data: ArchiveEntry.Data
    @State var showPicker = false

    @State var source: ImagePicker.Source = .library

    @State var showCameraAlert = false

    @State var imageName: String = ""
    @State var image: UIImage?

    @State var isEditing = false
    @State var selectedImage: Photo?
    @State var showFileAlert = false
    @State var appError: CapturingThePastError.ErrorType?

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
        VStack {
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

    func didDismissImagePicker() {
        // If an image was picked, then show the image name
        if image != nil {
            showPicker = true
            // Set proposed imagename to the ref sequence
            data.date = Date()
            imageName = data.generatePhotoFileName()
        }
    }

    func addPhoto() {
        do {
            if let image = image {
                let photo = Photo(id: imageName, image: image)
                try photo.save()
                data.photo = photo
            }
        } catch {
            showFileAlert = true
            appError = CapturingThePastError.ErrorType(error: error as! CapturingThePastError)
        }
    }

    var body: some View {
        VStack {
            Form {
                Picker(selection: $data.repositoryID, label: Text("Repository")) {
                    // TODO: In future indicate if entries repo is no longer in list
                    ForEach(repositories, id: \.id) { repo in
                        Text(repo.nameCodeString)
                    }
                }
                VStack {
                    LabelledTextView("Catalogue reference", text: $data.catReference)
                    LabelledStepper("Item", value: $data.item)
                    LabelledStepper("Sub Item", value: $data.subItem)
                    LabelledTextView("Special Case:", text: $data.specialCase)
                    LabelledTextView("Note", text: $data.note)
                    LabelledText(title: "Ref", text: data.referenceSequence).foregroundColor(Color.accentColor)
                }
                HStack {
                    Image(uiImage: data.photo.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
                    pickerButtons
                }
                LabelledText(title: "Photo", text: data.photo.id).foregroundColor(Color.accentColor)
            }


        }
        .background(BackgroundImage())
        .sheet(isPresented: $showPicker, onDismiss: didDismissImagePicker) {
            if image == nil {
                ImagePicker(sourceType: source == .library ? .photoLibrary : .camera, selectedImage: $image)
                    .ignoresSafeArea()
            } else {
                VStack {
                    Text("Chosen image")
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
                    Divider()
                    Text("Filename: \(imageName)")
                    Divider()
                    HStack {
                        Button(action: {
                            addPhoto()
                            image = nil
                            showPicker = false

                        }) {
                            Text("Ok")
                        }
                        Spacer()
                        Button(action: {
                            imageName = ""
                            image = nil
                            showPicker = false

                        }) {
                            Text("Cancel")
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
            ArchiveEntryEditView(repositories: .constant(Repository.initialRepositories), data: .constant(ArchiveEntry.sampleEntries[0].data))
        }
    }
}
