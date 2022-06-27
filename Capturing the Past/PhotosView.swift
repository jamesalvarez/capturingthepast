//
//  PhotosView.swift
//  Capturing the Past
//
//  Created by James Alvarez on 27/06/2022.
//

import Foundation

import SwiftUI

struct PhotosView: View {
    @EnvironmentObject var vm: ViewModel
    var body: some View {
        NavigationView {
            VStack {
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)

                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.6)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.horizontal)
                }
                HStack {
                    Button {
                        vm.source = .camera
                        vm.showPhotoPicker()
                    } label: {
                        Text("Camera")
                    }
                    Button {
                        vm.source = .library
                        vm.showPhotoPicker()
                    } label: {
                        Text("Photos")
                    }
                }
                Spacer()
            }
            .sheet(isPresented: $vm.showPicker) {
                ImagePicker(sourceType: vm.source == .library ? .photoLibrary : .camera, selectedImage: $vm.image)
                    .ignoresSafeArea()
            }
            .navigationTitle("Selected photo")
        }
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView()
            .environmentObject(ViewModel())
    }
}
