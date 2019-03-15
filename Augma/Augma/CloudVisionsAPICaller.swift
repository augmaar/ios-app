//
//  CloudVisionsAPICaller.swift
//  Augma
//
//  Created by Lily Pham on 3/14/19.
//  Copyright © 2019 Chase Carnaroli. All rights reserved.
//

import Foundation
import Alamofire

class CloudVisionsAPICaller {
    private let apiKey = "AIzaSyCJrr9TUp39jOeIslX-hNVaKZ46qkxR35M"
    private var apiURL: URL {
        return URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
    }
    
    func detect(from image: UIImage, completion: @escaping (Any) -> Void) {
        guard let base64Image = base64EncodeImage(image) else {
            print("Error while base64 encoding image")
            //completion(nil)
            return
        }
        callGoogleVisionAPI(with: base64Image, completion: completion)
    }
    
    private func callGoogleVisionAPI(
        with base64EncodedImage: String,
        completion: @escaping (Any) -> Void) {
        let parameters: Parameters = [
            "requests": [
                [
                    "image": [
                        "content": base64EncodedImage
                    ],
                    "features": [
                        [
                            "type": "LABEL_DETECTION"
                        ]
                    ]
                ]
            ]
        ]
        let headers: HTTPHeaders = [
            "X-Ios-Bundle-Identifier": Bundle.main.bundleIdentifier ?? "",
            ]
        Alamofire.request(
            apiURL,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers)
            .responseJSON { response in
                if response.result.isFailure {
                    completion(response)
                    return
                }
                //let json = try? JSONSerialization.jsonObject(with: response, options: [])
                completion(response.result.value)
        }
        
    }
    
    private func base64EncodeImage(_ image: UIImage) -> String? {
        return image.pngData()?.base64EncodedString(options: .endLineWithCarriageReturn)
    }
}
