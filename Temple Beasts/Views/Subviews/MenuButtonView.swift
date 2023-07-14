//
//  MenuButtonView.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 8.06.2023.
//

import SwiftUI

struct MenuButtonView: View {
    var text: String
    var body: some View {
        Image(text)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 280)
//            .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 50, alignment: .center)

    }
}

struct MenuButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MenuButtonView(text: "SinglePlayer")
    }
}
