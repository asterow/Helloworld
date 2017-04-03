//
//  ViewController.swift
//  Helloworld
//
//  Created by Astero on 20/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelHello: UILabel!
    @IBOutlet weak var textFieldHello: UITextField!
    @IBOutlet weak var buttonHello: UIButton!
    @IBAction func tapButtonHello(_ sender: Any) {
        labelHello.text = "Hello \(textFieldHello.text!)!"
        textFieldHello.resignFirstResponder()
        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

