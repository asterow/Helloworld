//
//  GifGiphy.swift
//  Helloworld
//
//  Created by Astero on 30/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class GifGiphy {
    let minUrl : String
    let originUrl : String
    let id: String
    var minImage: UIImage?
    var minNSDataImage: NSData?
    var originImage: UIImage?
    var originNSDataImage: NSData?
    var mapImage: UIImage?
    var location: CLLocationCoordinate2D?
    var gif: Gif?
    
    init(id: String, minUrl: String, originUrl: String) {
        self.id = id
        self.minUrl = minUrl
        self.originUrl = originUrl
    }
    init(gif: Gif) {
        
        self.id = gif.id!
        self.minUrl = gif.minUrl!
        self.originUrl = gif.originUrl!
        self.gif = gif
        if gif.latitude != 0, gif.longitude != 0 {
            self.location = CLLocationCoordinate2D(latitude: gif.latitude, longitude: gif.longitude)
            print("init Giphy: location = \(self.location)")
        }
        loadGIF()
    }
    
    func loadGIF() {
        guard let gif = self.gif else {
            print("gif's not defined")
            return
        }
        guard let gifMinURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(gif.id!)_min") else {
            print("can't create gifURL \(gif.id!)_min")
            return
        }
        guard let minImage = UIImage.gif(url: gifMinURL.absoluteString) else {
            print("can't load min UIImage, adding minNSDataImage to FileSystem")
            return
        }
        self.minImage = minImage
        guard let gifMaxfURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(gif.id!)_max") else {
            print("can't create gifURL \(gif.id!)_max")
            return
        }
        guard FileManager.default.fileExists(atPath: gifMaxfURL.path) else {
            return
        }
        guard let maxImage = UIImage.gif(url: gifMaxfURL.absoluteString) else {
            print("can't load origin UIImage")
            return
        }
        self.originImage = maxImage
    }
}
