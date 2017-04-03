//
//  HelloViewController.swift
//  Helloworld
//
//  Created by Astero on 21/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit

class HelloViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helloLabel.text = "Yo bitches !"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
