//
//  Filters.swift
//  PhotoProcessor
//
//  Created by Aleksey Pestov on 06.04.2021.
//

import Foundation
import UIKit
import CoreImage

enum FilterError: Error {
    case noImage
    case ciFailed
    case unknowFilter(String)
    case processingError
}

class ImageProcessor {
    let context: CIContext
    let filters = [
        "Sepia": applySepia,
        "Bloom": applyBloom,
        "Blur": applyBlur,
    ]
    var knownFilters: [String] {
        [String](filters.keys)
    }
    
    init() {
        context = CIContext()
    }
    
    func applyFilter(_ filter: String?, to uiImage: UIImage?, withPower power: Double) throws -> UIImage {
        guard let uiImage = uiImage else {
            throw FilterError.noImage
        }
        guard let image = uiImage.ciImage ?? CIImage(image: uiImage) else {
            throw FilterError.ciFailed
        }
        guard let filter = filter else {
            throw FilterError.unknowFilter("none")
        }
        guard let filterFunc = filters[filter] else {
            throw FilterError.unknowFilter(filter)
        }
        guard let newImage = filterFunc(image, power) else {
            throw FilterError.processingError
        }
        guard let fixedImage = context.createCGImage(newImage, from: image.extent) else {
            throw FilterError.processingError
        }
        return UIImage(cgImage: fixedImage)
    }
    
    static func applySepia(image: CIImage, power: Double) -> CIImage? {
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        sepiaFilter?.setValue(image, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(power, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
    static func applyBlur(image: CIImage, power: Double) -> CIImage? {
        let sepiaFilter = CIFilter(name:"CIGaussianBlur")
        sepiaFilter?.setValue(image, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(power * 30.0, forKey: kCIInputRadiusKey)
        return sepiaFilter?.outputImage
    }
    static func applyBloom(image: CIImage, power: Double) -> CIImage?
    {
        let bloomFilter = CIFilter(name:"CIBloom")
        bloomFilter?.setValue(image, forKey: kCIInputImageKey)
        bloomFilter?.setValue(power, forKey: kCIInputIntensityKey)
        bloomFilter?.setValue(10.0, forKey: kCIInputRadiusKey)
        return bloomFilter?.outputImage
    }
}
