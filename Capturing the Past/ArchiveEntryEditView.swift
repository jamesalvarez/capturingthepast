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
    @EnvironmentObject var repositoriesStore: RepositoriesStore
    @EnvironmentObject var archiveEntriesStore: ArchiveEntriesStore

    enum EditState {
        case DataEntry, PhotoPicking, Confirmation
    }

    enum InfoPopupContent {
        case RepositorySelector, CatalogueReference, ItemLevel, SubItemLevel, SpecialCases, Note, Ref
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
    @State var infoPopupText: String = ""
    @State var infoPopupHeader: String = ""
    @State var appError: CapturingThePastError.ErrorType?

    public func sheetVisible() -> Binding<Bool> {
        return Binding<Bool>(get: { self.editState != EditState.DataEntry },
                             set: { _ in })
    }

    func showInfoPopup(_ type: InfoPopupContent) {
        switch type {
        case .RepositorySelector:
            infoPopupHeader = "Repository Selector"
            infoPopupText = "The repository selector sets the first segment of the catalogue reference. Normally this is a country code followed an Archon code. \n\nThe numbering scheme is used in The National Archive\'s Discovery Catalogue. The segment is inserted in the file name to associate the image with the source institution. \n\nAdd custom Archon Codes to identify other sources."
        case .CatalogueReference:
            infoPopupHeader = "Catalogue Reference"
            infoPopupText = "Enter the catalogue number to associate photos with a specific document in a catalogue.\n\nWhen working with sequences such as entire collections it may be convenient to use the optional controls below to increment the final levels of the catalogue reference. E.g. books or letters. Non sequential entry of reference numbers may be easier using a single text field.\n\nThe character limit for filenames is accumulated across all input fields though is not restricted as you may have a valid reason for creating filenames that do not work in common file systems. Instead a warning message is shown when 128 characters is exceeded, this would be a really long file name. Actual limits vary for according to file system, but 255 characters is likely to work."
        case .ItemLevel:
            infoPopupHeader = "Item Level"
            infoPopupText = "Optional - The incrementing and decrementing buttons are intended to help with sequential capture tasks such as working through a series or collection. The input is restricted to numeric values"
        case .SubItemLevel:
            infoPopupHeader = "Sub Item Level"
            infoPopupText = "Optional - The sub item is intended to  be used to associate photos with specific parts of an item. E.g. The individual pages of books or letters. \n\n\n\nFile names include a time stamp to enable unlimited numbers of photos for any reference number. \n\nThe sub item level is often used by projects to provide an additional level of catalogue description beyond the institutions catalogue numbering."
        case .SpecialCases:
            infoPopupHeader = "Special Cases"
            infoPopupText = "Optional - this control is intended to be reserved for special cases such as detached or torn document parts. The control adds a distinguishable identifier to the end of the reference using a combination of letters and numbers."
        case .Note:
            infoPopupHeader = "Note"
            infoPopupText = "Optional note field: Notes are stored with the reference in the log file."
        case .Ref:
            infoPopupHeader = "Ref"
            infoPopupText = "This is the final full reference that will appear the log file."
        }

        showingInfoPopup = true
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

    var body: some View {
        ZStack {
            SideMenu(onAppear: sideMenuLinkClicked)
            mainView
                .offset(x: showingMenu ? UIScreen.main.bounds.width : 0.0, y: 0)
                .animation(backfromNavLink ? nil : .easeOut, value: showingMenu)
        }
    }

    var mainView: some View {
        ScrollView(.vertical) {
            VStack {
                Form {
                    VStack {
                        LabelledControl(title: "Repository", infoClickAction: {
                            showInfoPopup(InfoPopupContent.RepositorySelector)
                        }) {
                            Picker(selection: $data.repositoryID, label: pickerLabel) {
                                // TODO: In future indicate if entries repo is no longer in list
                                ForEach(repositoriesStore.repositories, id: \.id) { repo in
                                    Text(repo.nameCodeString)
                                }
                            }.labelsHidden()
                        }

                        LabelledTextView(title: "Catalogue reference", text: $data.catReference) {
                            showInfoPopup(InfoPopupContent.CatalogueReference)
                        }
                        LabelledStepper(title: "Item", value: $data.item) {
                            showInfoPopup(InfoPopupContent.ItemLevel)
                        }
                        LabelledStepper(title: "Sub Item", value: $data.subItem) {
                            showInfoPopup(InfoPopupContent.SubItemLevel)
                        }
                        LabelledSpecialCaseControl(title: "Special Case:", value: $data.specialCase) {
                            showInfoPopup(InfoPopupContent.SpecialCases)
                        }
                        LabelledTextView(title: "Note", text: $data.note) {
                            showInfoPopup(InfoPopupContent.Note)
                        }
                        LabelledText(title: "Ref", text: data.referenceSequence ?? " ") {
                            showInfoPopup(InfoPopupContent.Ref)
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

                Text("Photo successfully added to archive")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            .padding(16)
            .background(Color(hex: "b37407").cornerRadius(12))
            .padding(.horizontal, 16)
        }
        .popup(isPresented: $showingInfoPopup, type: .default, closeOnTap: false, backgroundColor: .black.opacity(0.4)) {
            InfoPopup(header: $infoPopupHeader, text: $infoPopupText, showingInfoPopup: $showingInfoPopup)
        }
    }
}

struct ArchiveEntryEditView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ArchiveEntryEditView()
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
            .previewDisplayName("iPhone SE")

            NavigationView {
                ArchiveEntryEditView()
            }
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
            .previewDisplayName("iPhone 11 Pro Max")
        }
    }
}
