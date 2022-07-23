//
//  BackgroundImage.swift
//  Capturing the Past
//
//  Created by James Alvarez on 20/07/2022.
//

import SwiftUI

struct BackgroundImage: View {
    var body: some View {
        Image("back1")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(minWidth: 0, maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)

    }
}


