//
//  SwitfTool.swift
//  ReadCard
//
//  Created by 夜猫子 on 2023/10/20.
//

import UIKit
import Vision

@available(iOS 13.0, *)
class SwitfTool: NSObject {
    
    @objc class func recognizeText(image: UIImage,cardType: CardType, completion: @escaping (String?) -> Void) {
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
        switch cardType {
        case CardTypeIdentificationCard:
            request.recognitionLanguages = ["zh-Hans"] // 简体中文
            break
        case CardTypeSocialSecurityCard:
            request.recognitionLanguages = ["zh-Hans"] // 简体中文
            break
        case CardTypeThaiCard:
            request.recognitionLanguages = ["Thai"] //泰文
            break
        default:
            break
        }
        
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        do {
            try requestHandler.perform([request])
        } catch {
            print("Error performing text recognition: \(error.localizedDescription)")
            completion(nil)
        }
    }
    
}
