//
//  SoundManager.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 25.06.2023.
//

import Foundation
import AVKit

class SoundManager {
    
    static let shared = SoundManager()
    
    var player: AVAudioPlayer?
    
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "tada", withExtension: ".mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()

        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }

    }
    
    
}
