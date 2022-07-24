//
//  LabelledSpecialCaseControl.swift
//  Capturing the Past
//
//  Created by James Alvarez on 22/07/2022.
//

import Foundation

import SwiftUI

struct LabelledSpecialCaseControl: View {
    let title: String
    @Binding var value: String
    let infoClickAction: () -> Void

    let alphabet = "abcdefghijklmnopqrstuvwxyz"

    var valueInt: Binding<Int> {
        Binding<Int>(get: { return specialCaseToInteger(self.value) },
                        set: { self.value = integerToSpecialCase($0) })
    }


    var body: some View {
        LabelledControl(title: title, infoClickAction: infoClickAction) {
            HStack {
                TextField("Enter Value", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
                Stepper(title, value: valueInt, in: 0...999).labelsHidden()

            }
        }
    }

    func getCharacterInAlphabet(c: String) -> Int? {
        guard c.count == 1, let firstIndex = alphabet.firstIndex(of: Character(c)) else {
            return nil
        }

        let index = alphabet.distance(from: alphabet.startIndex, to: firstIndex)
        return index
    }
    func specialCaseToInteger(_ str: String) -> Int {
        let components = str.lowercased().components(separatedBy: ":")

        switch(components.count) {
        case 0:
            return 0
        case 1:
            guard let index = getCharacterInAlphabet(c: components[0]) else {
                return 0
            }
            return index
        case 2:
            guard let index = getCharacterInAlphabet(c: components[0]),
                  let number = Int(components[1]) else {
                return 0
            }
            return (number * 26) + index
        default:
            return 0
        }
    }

    func integerToSpecialCase(_ integer: Int) -> String {
        if (integer < 0) {
            return ""
        } else if (integer < 26) {
            return String(alphabet[integer]);
        } else {
            return "\(alphabet[integer % 26]):\(integer / 26)";
        }
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
