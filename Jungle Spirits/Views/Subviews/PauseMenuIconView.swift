//
//  PauseMenuIconView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 8.06.2023.
//

import SwiftUI

struct PauseMenuIconView: View {
    let imageName: String
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .foregroundColor(Color("AnotherPause"))
            .overlay {
                Image(imageName)
            }
            .frame(width: 59, height: 44)
    }
}

struct PauseMenuIconView_Previews: PreviewProvider {
    static var previews: some View {
        PauseMenuIconView(imageName: "iconMap")
    }
}
