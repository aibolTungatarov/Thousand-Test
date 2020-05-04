//
//  UIImageView+Extension.swift
//  Thousand-Test
//
//  Created by Aibol Tungatarov on 5/3/20.
//  Copyright © 2020 Aibol Tungatarov. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let imageCache = NSCache<AnyObject, AnyObject>()
class CustomImageView: UIImageView {
    var imageUrlString: String?
    func loadImageFromUrl(urlString: String) {
        imageUrlString = urlString
        guard let url = URL(string: urlString) else { return }
        image = nil
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        Alamofire.request(url)
            .validate()
            .responseJSON { (response) in
                DispatchQueue.main.async {
                    guard let data = response.data else { return }
                    let imageToCache = UIImage(data: data)
                    print("Getting image")
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    if let imageToCache = imageToCache {
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                    }
                }
        }
    }
}

extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage? {

        let maskImage = self.cgImage
        let width = self.size.width
        let height = self.size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitmapContext = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) //needs rawValue of bitmapInfo
        if let bitmapContext = bitmapContext, let maskImage = maskImage {
            bitmapContext.clip(to: bounds, mask: maskImage)
            bitmapContext.setFillColor(color.cgColor)
            bitmapContext.fill(bounds)
        
            //is it nil?
            if let cImage = bitmapContext.makeImage() {
                let coloredImage = UIImage(cgImage: cImage)
                return coloredImage
            } else {
                return nil
            }
        }
        return nil
    }
}
