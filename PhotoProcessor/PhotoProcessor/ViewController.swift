//
//  ViewController.swift
//  PhotoProcessor
//
//  Created by Aleksey Pestov on 05.04.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var filtersHolder: UIStackView!
    @IBOutlet weak var filtersPanel: UIStackView!
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var editedImageView: UIImageView!
    @IBOutlet weak var compareButton: UIButton!
    
    
    let imageProcessor = ImageProcessor()
    var selectedFilter: String? = nil
    var selectedPower = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let image = UIImage(named: "TestImage")
        originalImageView.image = image
        originalImageView.alpha = 1.0
        editedImageView.image = image
        editedImageView.alpha = 0.0
        
        addFilterButtons(names: imageProcessor.knownFilters)
        compareButton.isEnabled = false
    }

    func addFilterButtons(names: [String]) {
        let baseImage = #imageLiteral(resourceName: "ImageIcon")
        
        for name in names {
            let procImage = try! imageProcessor.applyFilter(name, to: baseImage, withPower: 1.0)
            let icon = UIImageView(image: procImage)
            icon.contentMode = .scaleAspectFit
            filtersHolder.addArrangedSubview(icon)
            
            let button = UIButton(type: .system)
            button.setTitle(name, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(filterPressed(sender:)), for: .touchUpInside)
            filtersHolder.addArrangedSubview(button)
        }
        filtersHolder.layoutIfNeeded()
    }
    
    @objc func filterPressed(sender: UIButton) {
        selectedFilter = sender.currentTitle
        updateFilter()
    }
    @IBAction func powerChanged(_ sender: UISlider) {
        selectedPower = Double(sender.value)
        if selectedFilter != nil {
            updateFilter()
        }
    }
    
    func updateFilter() {
        compareButton.isEnabled = true
        do {
            let processedImage = try imageProcessor.applyFilter(selectedFilter, to: originalImageView.image, withPower: selectedPower)
            editedImageView.image = processedImage
            
            UIView.animate(withDuration: 0.5) {
                self.originalImageView.alpha = 0.0
                self.editedImageView.alpha = 1.0
            }
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
        let hide = sender.isSelected
        self.filtersPanel.isUserInteractionEnabled = !hide
        UIView.animate(withDuration: 0.5, animations: {
            if hide {
                self.filtersPanel.alpha = 0.0
                sender.isSelected = false
            } else {
                self.filtersPanel.alpha = 0.85
                sender.isSelected = true
            }
        })
    }
    
    
    @IBAction func toggleCompare(_ sender: Any) {
        selectImage(isOriginal: self.originalImageView.alpha < 0.5)
    }
    @IBAction func imageTouchDown(_ sender: UIButton) {
        selectImage(isOriginal: true)
    }
    @IBAction func imageTouchUp(_ sender: UIButton) {
        selectImage(isOriginal: false)
    }
    func selectImage(isOriginal: Bool) {
        UIView.animate(withDuration: 0.5) {
            if isOriginal {
                self.originalImageView.alpha = 1.0
                self.editedImageView.alpha = 0.0
            } else {
                self.originalImageView.alpha = 0.0
                self.editedImageView.alpha = 1.0
            }
        }
    }
    
    
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

