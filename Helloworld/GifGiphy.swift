//
//  GifGiphy.swift
//  Helloworld
//
//  Created by Astero on 30/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import Foundation
import UIKit

class GifGiphy {
    let minUrl : String
    let originUrl : String
    let id: String
    var minImage: UIImage?
    var minNSDataImage: NSData?
    var originImage: UIImage?
    var originNSDataImage: NSData?
    
    init(id: String, minUrl: String, originUrl: String) {
        self.id = id
        self.minUrl = minUrl
        self.originUrl = originUrl
    }
}
