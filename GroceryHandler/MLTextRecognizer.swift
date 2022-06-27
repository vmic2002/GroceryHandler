//
//  MLTextRecognizer.swift
//  GroceryHandler
//
//  Created by Victor Micha on 6/27/22.
//

import Foundation
import UIKit
import MLKitTextRecognition
import MLKitVision

//code for this file is taken/copied from https://developers.google.com/ml-kit/vision/text-recognition/ios

func getPrices(image:UIImage)->[Double]{
    getPricesAsArray(image: image)
    
    while gotPrices==false{
        Thread.sleep(forTimeInterval: 1)
        print("still here")
        //after while loop prices will be complete
    }
    print("got prices became true")
    //print("there are \(prices.count) prices")
    
    var pricesCpy = [Double]()
    for price in prices {
        pricesCpy.append(price)
    }
    //reinitialize gotPrices and prices
    gotPrices = false
    prices = [Double]()
    return pricesCpy
}

func getPricesAsArray(image:UIImage){
 
    //print("A")
    let textRecognizer = TextRecognizer.textRecognizer()
    //print("B")
    let visionImage = VisionImage(image: image)
    //print("C")
    visionImage.orientation = image.imageOrientation
    //print("D")
    textRecognizer.process(visionImage) { result, error in
        guard error == nil, let result = result else {
            // Error handling
            print("Error getting text from picture")
            return
        }
        // Recognized text
        print("Text recognized")
        //let resultText = result.text
        var i = 0
        for block in result.blocks {
            let blockText = block.text
            //  let blockLanguages = block.recognizedLanguages
            // let blockCornerPoints = block.cornerPoints
            // let blockFrame = block.frame
            print("Block \(i): \(blockText)")
            for line in block.lines {
                let lineText = line.text
                // let lineLanguages = line.recognizedLanguages
                // let lineCornerPoints = line.cornerPoints
                // let lineFrame = line.frame
                print("LineText: \(lineText)")
                for element in line.elements {
                    let elementText = element.text
                    // let elementCornerPoints = element.cornerPoints
                    // let elementFrame = element.frame
                    if let cost = Double(elementText) {
                        print("The user entered a value price of \(cost)")
                        if (cost>0.0 && cost<300.0){//reasonable price range is in between 0 and 300 (arbitrary)
                            print("ADDED TO PRICES: \(cost)")
                            prices.append(cost)
                        }
                    } else {
                        print("Not a valid number: \(elementText)")
                    }
                    //print("ElementText: \(elementText)")
                }
            }
            i+=1
        }
        gotPrices = true
        print("Done going through whole text")
    }
    print("Done with get prices as array method")

}
