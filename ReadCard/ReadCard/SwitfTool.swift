//
//  SwitfTool.swift
//  ReadCard
//
//  Created by 夜猫子 on 2023/10/20.
//

import UIKit
import Vision

class SwitfTool: NSObject {
    
    @objc class func recognizeText(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }

        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Error recognizing text: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }

            let recognizedText = observations.compactMap { observation in
                return observation.topCandidates(1).first?.string
            }.joined(separator: " ")

            completion(recognizedText)
        }
        
        // 英文和简体中文
        request.recognitionLanguages = ["zh-Hans"] // 简体中文
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        do {
            try requestHandler.perform([request])
        } catch {
            print("Error performing text recognition: \(error.localizedDescription)")
            completion(nil)
        }
    }


    
    
}
