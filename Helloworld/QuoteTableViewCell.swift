//
//  QuoteTableViewCell.swift
//  Helloworld
//
//  Created by Astero on 22/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit

class QuoteTableViewCell: UITableViewCell {

    @IBOutlet weak var quoteLabel: UILabel!
    
    var quote: Quote? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
