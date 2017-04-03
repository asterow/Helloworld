//
//  SearchImageCollectionViewCell.swift
//  Helloworld
//
//  Created by Astero on 27/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit

class SearchImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
        
    @IBOutlet weak var gifButton: UIButton!
    
    var closureActionAddGiffButton: ((Void) -> Void)?
    
    var gifGiphy: GifGiphy?

    @IBAction func addGifButton(_ sender: Any) {
        closureActionAddGiffButton!()
    }
    
    @IBOutlet weak var searchGifTextField: UITextField!

}
