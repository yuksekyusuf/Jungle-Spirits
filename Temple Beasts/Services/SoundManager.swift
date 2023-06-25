//
//  SoundManager.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 25.06.2023.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static let shared = SoundManager()
    
    var player1: AVAudioPlayer?
    var player2: AVAudioPlayer?
    
    
    enum SoundOption: String {
        case move = "move"
    }
    
    
    func playMoveSound() {
        guard let url = Bundle.main.url(forResource: "move", withExtension: ".aiff") else { return }
        
        do {
            player1 = try AVAudioPlayer(contentsOf: url)
            player1?.play()

        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }

    }
    
    func playConvertSound() {
        guard let url = Bundle.main.url(forResource: "tada", withExtension: ".wav") else { return }
        
        do {
            player2 = try AVAudioPlayer(contentsOf: url)
            player2?.play()

        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }
    }
    
    func playOverSound() {
        guard let url = Bundle.main.url(forResource: "victory", withExtension: ".wav") else { return }
        
        do {
            player1 = try AVAudioPlayer(contentsOf: url)
            player1?.play()

        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }
    }
    
    
    
}
