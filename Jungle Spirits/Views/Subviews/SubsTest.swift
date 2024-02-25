////
////  SubsTest.swift
////  Temple Beasts
////
////  Created by Ahmet Yusuf Yuksek on 16.02.2024.
////
//

import SwiftUI
//
//struct MainDatabaseView: View {
////    @StateObject var pathManager = NavigationCoordinator()
//    @EnvironmentObject var pathManager: NavigationCoordinator
//
//    var body: some View {
//        NavigationStack(path: $pathManager.path) {
//            List {
//                Section {
//                    NavigationLink(value: Destination.tutorialPage) {
//                        Button {
//                            pathManager.path.append(Destination.tutorialPage)
//                        } label: {
//                            Label("Pilots", systemImage: "person.2")
//                        }
//                    }
//
//                    NavigationLink(value: Destination.gamePage) {
//                        Button {
//                            pathManager.path.append(Destination.gamePage)
//                        } label: {
//                            Label("Aircraft", systemImage: "airplane.circle")
//                        }
//                    }
//                } header: {
//                    Text("Database")
//                }
//            }
//            .navigationDestination(for: Destination.self, destination: { value in
//                switch value {
//                case .tutorialPage:
//                    TutorialView(gameCenterManager: GameCenterManager(currentPlayer: .player1), storyMode: false, navCoordinator: pathManager)
//                        .environmentObject(pathManager)
//                case .gamePage:
//                    TextView(text: "Something is wrong")
//                }
//            })
//        }
//    }
//}
//
//#Preview {
//    MainDatabaseView()
////        .environmentObject(NavigationCoordinator())
//}
