//
//  ViewController.swift
//  EggTimer
//
//  Created by Aleksey Pestov on 31.03.2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    var boilTimer: Timer = Timer()
    var alarmPlayer: AVAudioPlayer?
    
    let boilTimes = [
        "soft": 5 * 60,
        "medium": 7 * 60,
        "hard": 12 * 60
    ]
    var currentTime = 0
    var selectedTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else {
            print("Alarm sound not found!")
            return
        }
        // Try to load
        do {
            alarmPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            alarmPlayer?.prepareToPlay()
        } catch let error {
            print("Error while loading alarm sound: \(error.localizedDescription)")
        }
    }

    @IBAction func hardnessSelected(_ sender: UIButton) {
        selectedTime = boilTimes[sender.currentTitle!]!
        currentTime = selectedTime
        
        boilTimer.invalidate()
        boilTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: timerTick)
        boilTimer.fire()
    }
    
    func timerTick(timer: Timer) {
        currentTime -= 1
        progressBar.progress = 1.0 - (Float(currentTime) / Float(selectedTime))
        if currentTime <= 0 {
            timer.invalidate()
            titleLabel.text = "Done!"
            alarmPlayer?.currentTime = 0.0
            alarmPlayer?.play()
        } else {
            titleLabel.text = "Wait \(currentTime) seconds"
        }
    }
}

