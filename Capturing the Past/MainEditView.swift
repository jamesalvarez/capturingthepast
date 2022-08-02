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
struct MainEditView: View {
    @EnvironmentObject var repositoriesStore: RepositoriesStore
    @EnvironmentObject var archiveEntriesStore: ArchiveEntriesStore

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
    @State var popupContent: InfoPopup.InfoPopupContent = .RepositorySelector
    @State var appError: CapturingThePastError.ErrorType?

    public func sheetVisible() -> Binding<Bool> {
        return Binding<Bool>(get: { self.editState != EditState.DataEntry },
                             set: { _ in })
    }

    

    func showPhotoPicker(source newSource: ImagePicker.Source) {
        if data.referenceSequence == nil {
            showCameraAlert = true
            appError = CapturingThePastError.ErrorType(error: .referenceNotSet)
            return
        }

        source = newSource

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

    func imagePickerDismissed() {
        if image != nil {
            data.date = Date()
            imageName = data.generatePhotoFileName() ?? ""
            editState = EditState.Confirmation
            showConfirmationDialog = true
        } else {
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
            archiveEntriesStore.archiveEntries.append(ArchiveEntry(fromData: data))
            archiveEntriesStore.save()
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

    var menuButton: some View {
        Button(action: {
            backfromNavLink = false
            showingMenu.toggle()
        }) {
            Image(systemName: "line.horizontal.3")
                .foregroundColor(.white)
        }.accessibilityLabel("Main menu")
    }

    @ViewBuilder
    var pickerLabel: some View {
        if data.repositoryID == "" {
            Text("Choose repository").foregroundColor(Color(.placeholderText))
        } else {
            EmptyView()
        }
    }

    @State private var showingMenu = false
    @State private var backfromNavLink = false

    func sideMenuLinkClicked() {
        backfromNavLink = true
        showingMenu = false
    }

    func showInfoPopup(_ content: InfoPopup.InfoPopupContent) {
        popupContent = content
        showingInfoPopup = true
    }

    var body: some View {
        ZStack {
            SideMenu(onAppear: sideMenuLinkClicked)
                .offset(x: showingMenu ? 0.0 : 0 - UIScreen.main.bounds.width, y: 0)
                .animation(.easeOut, value: showingMenu)
            mainView
                .offset(x: showingMenu ? UIScreen.main.bounds.width : 0.0, y: 0)
                .animation(backfromNavLink ? nil : .easeOut, value: showingMenu)
        }
    }

    var mainView: some View {
        VStack {
            Form {
                Section {
                    LabelledControl(title: "Repository", infoClickAction: {
                        showInfoPopup(.RepositorySelector)
                    }) {
                        Picker(selection: $data.repositoryID, label: pickerLabel) {
                            // TODO: In future indicate if entries repo is no longer in list
                            ForEach(repositoriesStore.repositories, id: \.id) { repo in
                                Text(repo.nameCodeString)
                            }
                        }.labelsHidden()
                    }

                    LabelledTextView(title: "Catalogue reference", text: $data.catReference) {
                        showInfoPopup(.CatalogueReference)
                    }
                    LabelledStepper(title: "Item", value: $data.item) {
                        showInfoPopup(.ItemLevel)
                    }
                    LabelledStepper(title: "Sub Item", value: $data.subItem) {
                        showInfoPopup(.SubItemLevel)
                    }
                    LabelledSpecialCaseControl(title: "Special Case:", value: $data.specialCase) {
                        showInfoPopup(.SpecialCases)
                    }
                    LabelledTextView(title: "Note", text: $data.note) {
                        showInfoPopup(.Note)
                    }
                    LabelledText(title: "Ref", text: data.referenceSequence ?? " ") {
                        showInfoPopup(.Ref)
                    }.foregroundColor(Color.accentColor)
                }
            }
            .frame(width: 300, height: 520)
            HStack {
                Button { showPhotoPicker(source: .camera)
                } label: {
                    ButtonLabel(symbolName: "camera", label: "Camera")
                }
                Button { showPhotoPicker(source: .library)
                } label: {
                    ButtonLabel(symbolName: "photo", label: "Photos")
                }
            }
        }
        .navigationTitle("Capturing the Past")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                menuButton
            }
        }
        .background(BackgroundImage())
        .alert("Error", isPresented: $showCameraAlert, presenting: appError, actions: { cameraError in
            cameraError.button
        }, message: { cameraError in
            Text(cameraError.message)
        })
        .sheet(isPresented: $showImagePicker, onDismiss: imagePickerDismissed) {
            ImagePicker(sourceType: source == .library ? .photoLibrary : .camera, selectedImage: $image)
                .ignoresSafeArea()
        }
        .sheet(isPresented: $showConfirmationDialog, onDismiss: resetUIToDataEntry) {
            ConfirmationDialog(image: image!, imageName: imageName, referenceSequence: data.referenceSequence ?? "", archive: {
                addPhoto()
                resetUIToDataEntry()
            }, cancel: resetUIToDataEntry)
        }
        .popup(isPresented: $showToast, type: .floater(), position: .bottom, animation: .spring(), autohideIn: 4) {
            HStack(spacing: 8) {
                Image(systemName: "archivebox")
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)

                Text("Image saved and logged")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            .padding(16)
            .background(Color(hex: "b37407").cornerRadius(12))
            .padding(.horizontal, 16)
        }
        .popup(isPresented: $showingInfoPopup, type: .default, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
            InfoPopup(popupContent: $popupContent, showingInfoPopup: $showingInfoPopup)
        }
    }
}

struct ArchiveEntryEditView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                MainEditView()
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")

            NavigationView {
                MainEditView()
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
            .previewDisplayName("iPhone 11 Pro Max")
        }
    }
}
