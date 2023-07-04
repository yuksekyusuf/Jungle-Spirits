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
    var musicPlayer: AVAudioPlayer?
    
    
    enum SoundOption: String {
        case move = "move"
    }
    
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "soundtrack", withExtension: "wav") else { return }

        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            
            musicPlayer?.numberOfLoops = -1 // add this line to loop the music indefinitely
            musicPlayer?.prepareToPlay() // prepare the player for playback by preloading its buffers.
            musicPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pauseOrPlayMusic() {
        // Check if the player is currently playing
        if musicPlayer?.isPlaying == true {
            // If it is, pause the music
            musicPlayer?.pause()
        } else {
            // If it's not, play the music
            musicPlayer?.play()
        }
    }
    
    func playMoveSound() {
        
        guard UserDefaults.standard.bool(forKey: "sound") else { return }
        guard let url = Bundle.main.url(forResource: "move", withExtension: ".aiff") else { return }
        
        do {
            
            player1 = try AVAudioPlayer(contentsOf: url)
            player1?.play()

        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }

    }
    
    func playConvertSound() {
        guard UserDefaults.standard.bool(forKey: "sound") else { return }

        guard let url = Bundle.main.url(forResource: "tada", withExtension: ".wav") else { return }
        
        do {
            player2 = try AVAudioPlayer(contentsOf: url)
            player2?.play()

        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }
    }
    
    func playOverSound() {
        guard UserDefaults.standard.bool(forKey: "sound") else { return }

        guard let url = Bundle.main.url(forResource: "victory", withExtension: ".wav") else { return }
        
        do {
            player1 = try AVAudioPlayer(contentsOf: url)
            player1?.play()

        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }
    }
    
    
    
}
