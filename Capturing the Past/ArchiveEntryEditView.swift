//
//  ContentView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 14/06/2022.
//

import PopupView
import SwiftUI
/**
 * View for viewing and editing an archive entry
 */
struct ArchiveEntryEditView: View {
    @Binding var repositories: [Repository]
    @Binding var archiveEntries: [ArchiveEntry]
    let saveAction: () -> Void

    enum EditState {
        case DataEntry, PhotoPicking, Confirmation
    }

    @State var editState: EditState = .DataEntry
    @State var source: ImagePicker.Source = .library
    @State var showCameraAlert = false
    @State var data: ArchiveEntry.Data = .init()

    @State var imageName: String = ""
    @State var image: UIImage?

    @State var isEditing = false
    @State var selectedImage: Photo?
    @State var showFileAlert = false
    @State var showImagePicker = false
    @State var showConfirmationDialog = false
    @State var showToast = false
    @State var showingInfoPopup = false
    @State var appError: CapturingThePastError.ErrorType?

    public func sheetVisible() -> Binding<Bool> {
        return Binding<Bool>(get: { self.editState != EditState.DataEntry },
                             set: { _ in })
    }

    func showPhotoPicker() {
        do {
            if source == .camera {
                try ImagePicker.checkPermissions()
            }
            editState = EditState.PhotoPicking
            showImagePicker = true
        } catch {
            showCameraAlert = true
            appError = CapturingThePastError.ErrorType(error: error as! CapturingThePastError)
            editState = EditState.DataEntry
        }
    }

    func addPhoto() {
        do {
            if let image = image {
                let photo = Photo(id: imageName, image: image)
                try photo.save()
                data.photo = photo
            }

            // Add data to repositories list and save
            archiveEntries.append(ArchiveEntry(fromData: data))
            saveAction()
            showToast = true
        } catch {
            showFileAlert = true
            appError = CapturingThePastError.ErrorType(error: error as! CapturingThePastError)
        }
    }

    func resetUIToDataEntry() {
        showImagePicker = false
        showConfirmationDialog = false
        imageName = ""
        image = nil
        editState = EditState.DataEntry
    }

    var pickerButtons: some View {
        HStack {
            Button {
                source = .camera
                showPhotoPicker()
            } label: {
                ButtonLabel(symbolName: "camera", label: "Camera").frame(width: 150)
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
                ButtonLabel(symbolName: "photo", label: "Photos").frame(width: 150)
            }
        }
    }

    var repositoriesEditButton: some View {
        NavigationLink(destination: RepositoriesView(repositories: $repositories) {
            saveAction() // Triggers root save action when saving repositories
        }) {
            Image(systemName: "building.columns")

        }.accessibilityLabel("Repository Settings")
    }

    var body: some View {
        ScrollView(.vertical) {
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
                }
                .frame(height: 520)
                pickerButtons
            }
        }
        .navigationTitle("Capturing the Past")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                repositoriesEditButton
            }
        }
        .background(BackgroundImage())
        .sheet(isPresented: $showImagePicker, onDismiss: {
            if image != nil {
                data.date = Date()
                imageName = data.generatePhotoFileName()
                editState = EditState.Confirmation
                showConfirmationDialog = true
            } else {
                editState = EditState.DataEntry
            }
        }) {
            ImagePicker(sourceType: source == .library ? .photoLibrary : .camera, selectedImage: $image)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showConfirmationDialog, onDismiss: resetUIToDataEntry) {
            Form {
                VStack {
                    Text("Chosen image")
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .shadow(color: .black.opacity(0.6), radius: 2, x: 2, y: 2)
                    Text("Filename: \(imageName)").multilineTextAlignment(.leading).lineLimit(nil).minimumScaleFactor(0.01)
                    Divider()
                    HStack(spacing: 20) {
                        Button(action: {
                            addPhoto()
                            resetUIToDataEntry()
                        }) {
                            Text("Ok")
                        }
                        Button(action: resetUIToDataEntry) {
                            Text("Cancel")
                        }
                    }
                }
            }
        }
        .popup(isPresented: $showToast, type: .toast, position: .bottom, autohideIn: 2, dragToDismiss: true) {
            Text("Photo added to archive")
                .frame(width: 200, height: 30)
                .background(Color.black)
                .cornerRadius(5)
        }
        .popup(isPresented: $showingInfoPopup) {

        }
    }
}

struct ArchiveEntryEditView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArchiveEntryEditView(repositories: .constant(Repository.initialRepositories), archiveEntries: .constant(ArchiveEntry.sampleEntries)) {}
        }
    }
}
