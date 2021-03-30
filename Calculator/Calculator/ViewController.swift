//
//  ViewController.swift
//  Calculator
//
//  Created by Aleksey Pestov on 30.03.2021.
//

import UIKit

class ViewController: UIViewController {

    var model: Calculator!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        model = Calculator(onUpdate: showComputedResult)
    }

    func showComputedResult(result: String) {
        resultLabel.text = result
    }

    @IBAction func onNumberPressed(_ sender: UIButton) {
        model.sendChar(char: sender.currentTitle?.first ?? "?")
    }
    
    @IBAction func onActionPressed(_ sender: UIButton) {
        switch sender.currentTitle {
        case "AC":
            model.sendAction(action: .clear)
        case "+/-":
            model.sendAction(action: .sign)
        case "%":
            model.sendAction(action: .percent)
        case "/":
            model.sendAction(action: .divide)
        case "*":
            model.sendAction(action: .multiply)
        case "+":
            model.sendAction(action: .plus)
        case "-":
            model.sendAction(action: .minus)
        case "=":
            model.sendAction(action: .run)
        default:
            print("Unknown action: \(sender.currentTitle ?? "Unknown")")
        }
    }
}

