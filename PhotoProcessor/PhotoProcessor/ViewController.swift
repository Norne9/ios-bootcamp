//
//  ViewController.swift
//  PhotoProcessor
//
//  Created by Aleksey Pestov on 05.04.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var filtersView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        filtersView.alpha = 0.8
        addFilterButtons(names: (1...5).map {"Filter \($0)"})
    }

    func addFilterButtons(names: [String]) {
        for name in names {
            let button = UIButton(type: .system)
            button.setTitle(name, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            filtersView.addArrangedSubview(button)
        }
        filtersView.layoutIfNeeded()
    }
    
    @IBAction func toggleFilters(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            if self.filtersView.isHidden {
                self.filtersView.isHidden = false
                sender.isSelected = true
            } else {
                self.filtersView.isHidden = true
                sender.isSelected = false
            }
        }
    }
}

