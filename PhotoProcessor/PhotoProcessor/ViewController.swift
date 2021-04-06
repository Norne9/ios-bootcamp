//
//  ViewController.swift
//  PhotoProcessor
//
//  Created by Aleksey Pestov on 05.04.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var filtersView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    
    let imageProcessor = ImageProcessor()
    var originalImage: UIImage?
    var processedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        originalImage = imageView.image
        processedImage = originalImage
        
        filtersView.alpha = 0.8
        addFilterButtons(names: imageProcessor.knownFilters)
    }

    func addFilterButtons(names: [String]) {
        for name in names {
            let button = UIButton(type: .system)
            button.setTitle(name, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
            filtersView.addArrangedSubview(button)
        }
        filtersView.layoutIfNeeded()
    }
    
    @objc func filterPressed(sender: UIButton) {
        do {
            processedImage = try imageProcessor.applyFilter(sender.currentTitle, to: originalImage, withPower: 1.0)
            imageView.image = processedImage
        } catch FilterError.noImage {
            showError("No image!")
        } catch FilterError.processingError {
            showError("Error during processing!")
        } catch let FilterError.unknowFilter(f) {
            showError("Filter \(f) not found!")
        } catch FilterError.ciFailed {
            showError("Internal error!")
        } catch {
            showError("Unexpected error!")
        }
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
    
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

