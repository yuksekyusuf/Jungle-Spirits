//
//  TestView.swift
//  Jungle Spirits
//
//  Created by Ahmet Yusuf Yuksek on 21.06.2024.
//

import SwiftUI
import SuperwallKit

struct TestView: View {
    var body: some View {
        Button("Paywall") {
            Superwall.shared.register(event: "campaign_trigger")

        }
    }
}

#Preview {
    TestView()
}
