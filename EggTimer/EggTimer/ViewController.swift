//
//  ViewController.swift
//  EggTimer
//
//  Created by Aleksey Pestov on 31.03.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    let boilTimes = [
        "soft": 5,
        "medium": 7 * 60,
        "hard": 12 * 60
    ]
    weak var boilTimer: Timer? = nil
    var currentTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func hardnessSelected(_ sender: UIButton) {
        guard let boilTime = boilTimes[sender.currentTitle ?? "nil"] else {
            print("Unknown hardness: \(sender.currentTitle ?? "nil")")
            return
        }
        print(boilTime)
        
        boilTimer?.invalidate()
        currentTime = boilTime
        boilTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: timerTick)
        boilTimer?.fire()
    }
    
    func timerTick(timer: Timer) {
        currentTime -= 1
        if currentTime <= 0 {
            timer.invalidate()
            titleLabel.text = "Done!"
        } else {
            titleLabel.text = "Wait \(currentTime) seconds"
        }
    }
}

