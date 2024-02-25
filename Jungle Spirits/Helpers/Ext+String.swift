//
//  Ext+String.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 9.02.2024.
//

import Foundation

extension String {
    var capitalizedSentence: String {
        // 1
        let firstLetter = self.prefix(1).capitalized
        // 2
        let remainingLetters = self.dropFirst().lowercased()
        // 3
        return firstLetter + remainingLetters
    }
}
