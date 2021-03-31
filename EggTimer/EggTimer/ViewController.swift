//
//  ViewController.swift
//  EggTimer
//
//  Created by Aleksey Pestov on 31.03.2021.
//

import UIKit

class ViewController: UIViewController {

    let times = [
        "soft": 5,
        "medium": 7,
        "hard": 12
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func hardnessSelected(_ sender: UIButton) {
        guard let cookTime = times[sender.currentTitle ?? "nil"] else {
            print("Unknown hardness: \(sender.currentTitle ?? "nil")")
            return
        }
        print(cookTime)
    }
}

