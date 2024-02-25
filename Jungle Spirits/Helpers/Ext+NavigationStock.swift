////
////  Ext+NavigationStock.swift
////  Temple Beasts
////
////  Created by Ahmet Yusuf Yuksek on 23.02.2024.
////
//
//import SwiftUI
//
//struct NavigationStack<Content: View>: View {
//    @EnvironmentObject var gameCenterManager: GameCenterManager
//    @Binding var path: [Int]
//    let content: () -> Content
//    
////    @State private var navigationPath: [Int] = []
//    
//    init(path: Binding<[Int]>, @ViewBuilder content: @escaping () -> Content) {
//        self._path = path
//        self.content = content
////        self._navigationPath = State(initialValue: path.wrappedValue)
//    }
//    
//    var body: some View {
//        VStack {
//            content()
////                .navigationBarTitle("Navigation Stack Example")
//            
//            // Use ForEach to iterate over navigationPath
//            // and conditionally navigate based on each path element
//            ForEach(gameCenterManager.path, id: \.self) { destination in
//                NavigationLink(destination: TutorialView(gameCenterManager: gameCenterManager,storyMode: true),
//                               tag: destination,
//                               selection: $gameCenterManager.last) {
//                    EmptyView()
//                }
//                .isDetailLink(false)
//                .hidden()
//            }
//        }
//        .onReceive(path.publisher) { newPath in
//            // Update navigationPath when path changes
//            gameCenterManager.pat = newPath
//        }
//    }
//}
