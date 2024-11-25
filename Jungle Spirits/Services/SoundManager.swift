//
//  SoundManager.swift
//  Temple Beasts
//
//  Created by Ahmet Yusuf Yuksek on 25.06.2023.
//

import Foundation
import AVFoundation
import UIKit

class SoundManager {
    static let shared = SoundManager()

    var player1: AVAudioPlayer?
    var player2: AVAudioPlayer?
    var countDownPlayer: AVAudioPlayer?
    var musicPlayer: AVAudioPlayer?

    private init() {}

    enum SoundOption: String {
        case move
    }

    func startPlayingIfNeeded() {
        if UserDefaults.standard.bool(forKey: "music") {
            playBackgroundMusic()
        }
    }
    
    func playCountDown() {
        guard UserDefaults.standard.bool(forKey: "sound") else { return }
        guard let url = Bundle.main.url(forResource: "countdown", withExtension: ".mp3") else { return }
        do {
            countDownPlayer = try AVAudioPlayer(contentsOf: url)
            countDownPlayer?.play()
        } catch let error {
            print("Countdown player has an error: \(error.localizedDescription)")
        }
    }

    func playBackgroundMusic() {
        guard UserDefaults.standard.bool(forKey: "music") else { return }
        guard let url = Bundle.main.url(forResource: "soundtrack", withExtension: ".wav") else { return }
        

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to play on the background */
                UIApplication.shared.beginReceivingRemoteControlEvents()

                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer!.numberOfLoops = -1 // Infinite loop
                musicPlayer!.prepareToPlay()
                musicPlayer!.play()
            } catch {
                print("Could not create audio player")
                return
            }
        }

    func stopBackgroundMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
        }

    func playMoveSound() {
        guard UserDefaults.standard.bool(forKey: "sound") else { return }
        guard let url = Bundle.main.url(forResource: "move", withExtension: ".wav") else { return }

        do {
            player1 = try AVAudioPlayer(contentsOf: url)
            player1?.play()
        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }
    }

    func playConvertSound() {
        guard UserDefaults.standard.bool(forKey: "sound") else { return }

        guard let url = Bundle.main.url(forResource: "convert", withExtension: ".wav") else { return }

        do {
            player2 = try AVAudioPlayer(contentsOf: url)
            player2?.play()
        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }
    }

    func playOverSound() {
        guard UserDefaults.standard.bool(forKey: "sound") else { return }

        guard let url = Bundle.main.url(forResource: "victory", withExtension: ".mp3") else { return }

        do {
            player1 = try AVAudioPlayer(contentsOf: url)
            player1?.play()
        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }
    }
    
    func playLoseSound() {
        guard UserDefaults.standard.bool(forKey: "sound") else { return }

        guard let url = Bundle.main.url(forResource: "lose", withExtension: ".mp3") else { return }

        do {
            player1 = try AVAudioPlayer(contentsOf: url)
            player1?.play()
        } catch let error {
            print("Audio player error: \(error.localizedDescription)")
        }
    }
    
    func turnDownMusic() {
        musicPlayer?.volume = 0.25
    }
    
    func playLowerBackground() {
        guard UserDefaults.standard.bool(forKey: "music") else { return }
        guard let url = Bundle.main.url(forResource: "soundtrack", withExtension: ".wav") else { return }

            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
                try AVAudioSession.sharedInstance().setActive(true)

                /* The following line is required for the player to play on the background */
                UIApplication.shared.beginReceivingRemoteControlEvents()

                musicPlayer = try AVAudioPlayer(contentsOf: url)
                musicPlayer!.numberOfLoops = -1 // Infinite loop
                musicPlayer!.prepareToPlay()
                musicPlayer!.volume = 0.25
                musicPlayer!.play()
            } catch {
                print("Could not create audio player")
                return
            }


    }
    
    func turnUpMusic() {
        musicPlayer?.volume = 1.0
    }
    
    func pauseMusic() {
        musicPlayer?.pause()
    }
    func resumeMusic() {
        musicPlayer?.play()
    }
}
