//
//  quoteDetailViewController.swift
//  Helloworld
//
//  Created by Astero on 22/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit

class quoteDetailViewController: UIViewController {

    @IBOutlet weak var bodyQuoteLabel: UILabel!
    @IBOutlet weak var authorQuoteLabel: UILabel!
   
    var quote: Quote? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyQuoteLabel.text = quote?.body ?? "Body"
        authorQuoteLabel.text = quote?.author ?? "Author"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
