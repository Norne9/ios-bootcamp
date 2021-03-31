//
//  ViewController.swift
//  Xylophone
//
//  Created by Aleksey Pestov on 30.03.2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var notePlayers: [String: AVAudioPlayer] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadSounds()
    }
    
    func loadSounds() {
        // Set audio category to playback
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        } catch let error {
            print("Failed to set category: \(error.localizedDescription)")
        }
        
        // Load sounds
        let sounds = "ABCDEFG"
        for csound in sounds {
            // Char to string
            let sound = String(csound)
            // Try to find path
            guard let url = Bundle.main.url(forResource: sound, withExtension: "wav", subdirectory: "Sounds") else {
                print("File for \(sound) sound not found!")
                continue
            }
            // Try to load
            do {
                let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                player.prepareToPlay()
                notePlayers[sound] = player
            } catch let error {
                print("Error while loading \(sound): \(error.localizedDescription)")
            }
        }
    }

    @IBAction func keyPressed(_ sender: UIButton) {
        let sound = sender.currentTitle ?? "Unknown"
        if let player = notePlayers[sound] {
            player.currentTime = 0.0;
            player.play()
        } else {
            print("Player for \(sound) not found!")
        }
        
        // Dim button
        sender.superview?.alpha /= 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.superview?.alpha *= 2.0
        }
    }
    
}

