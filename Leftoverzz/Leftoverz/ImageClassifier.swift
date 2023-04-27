//
//  ImageClassifier.swift
//  Leftoverz
//
//  Created by Jasmine Parekh on 4/18/23.
//

import Foundation
import SwiftUI
import CoreML
import Vision
import CoreImage

class ImageClassifier: ObservableObject {
    
    @Published private var classifier = Classifier()
    
    var imageClass: String? {
        classifier.results
    }
        
    // MARK: Intent(s)
    func detect(uiImage: UIImage) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        classifier.detect(ciImage: ciImage)
        
    }
        
}

struct Classifier {
    
    private(set) var results: String?
    
    mutating func detect(ciImage: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: MobileNetV2(configuration: MLModelConfiguration()).model)
        else {
            return
        }
         
        let request = VNCoreMLRequest(model: model)
        
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        
        try? handler.perform([request])
//        VNRecognizedObjectObservation
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
//        print(results)
        if let firstResult = results.first {
            self.results = firstResult.identifier
        }
        
    }
    
}
