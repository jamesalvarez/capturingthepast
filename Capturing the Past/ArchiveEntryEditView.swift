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
    @State var image: UIImage?
    @State var source: ImagePicker.Source = .library

    @State var showCameraAlert = false
    @State var imageName: String = ""
    @State var isEditing = false
    @State var selectedImage: Photo?
    @State var showFileAlert = false
    @State var appError: CapturingThePastError.ErrorType?


    func showPhotoPicker() {
        do {
            if source == .camera {
                try ImagePicker.checkPermissions()
            }
            // Set imagename to the ref sequence (TODO: check for file existing)
            imageName = sanitizeFilename(input: data.referenceSequence)
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
                VStack {
                    Image(uiImage: data.photo.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
                    Text(data.photo.id)
                }
            }
        }.padding(.horizontal)
    }

    var dataFields: some View {
        VStack {
            // TODO: In future indicate if entries repo is no longer in list
            Picker(selection: $data.repositoryID, label: Text("Repository")) {
                ForEach(repositories, id:\.id) { repo in
                    Text(repo.nameCodeString)
                }
            }

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
        // If an image was picked, then show the image name
        if image != nil {
            showPicker = true
        }
    }

    func sanitizeFilename(input: String) -> String {
        let tag = String(input.map {
            $0 == "/" ? "_" : ($0 == " " ? "_" : $0)
        })

        var fileName = tag
        var appendNumber = 1
        while FileManager().imageWithFilenameExists(fileName) {
            appendNumber += 1
            fileName = "\(tag)_\(appendNumber)"
        }

        return fileName
    }

    func addPhoto() {
        // Santize imageName for file
        imageName = sanitizeFilename(input: imageName)

        let photo = Photo(id: imageName)
        do {
            try FileManager().saveImage("\(photo.id)", image: image!)
            data.photo = Photo(id: imageName)
        } catch {
            showFileAlert = true
            appError = CapturingThePastError.ErrorType(error: error as! CapturingThePastError)
        }
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
                    Text("Chosen image")
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
                    Divider()
                    Text("Filename")
                    TextField("Filename", text: $imageName)
                    Divider()
                    HStack {
                        Button(action: {
                            if imageName == sanitizeFilename(input: imageName) {
                                addPhoto()
                                image = nil
                                showPicker = false
                            }
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
            ArchiveEntryEditView(repositories: .constant(Repository.initialRepositories), data: .constant(ArchiveEntry.sampleEntries[0].data))
        }
    }
}
