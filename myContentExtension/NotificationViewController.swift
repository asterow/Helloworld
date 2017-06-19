//
//  NotificationViewController.swift
//  myContentExtension
//
//  Created by frederic.THEAULT on 16/06/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI


class NotificationViewController: UIViewController, UNNotificationContentExtension, UITableViewDataSource, UITableViewDelegate {
    
//    @IBOutlet var tableView: UITableView?
    //@IBOutlet var label: UILabel?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad !")
//        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        print("didReceive !")

        //self.label?.text = notification.request.content.body
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection !")
        return 5
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat.ini
//        return CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
//
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "licomTableViewCell", for: indexPath) as? LicomTableViewCell
        {
            cell.cellImageView.image = UIImage(named: "Image")
            cell.priceLabel.text = "1200 E"
            cell.locationLabel.text = "PARIS 12E (75012)"
            cell.typeLabel.text = "Appartement"
            cell.surfaceLabel.text  = "45m2"
            cell.roomLabel.text = "2 pièces"
            print("return cell !")
            return cell
        }

//        cell.textLabel?.text = "YOHOOO"
//        cell.textLabel?.textColor = UIColor.white
        print("return UITableViewCell() !")

        return UITableViewCell()
    }
    
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LicomTableViewCell") as? LicomTableViewCell else {
//            print("cellForRowAt: Guard !")
//            return UITableViewCell()
//        }
//        print("cellForRowAt: return !")
//        return cell
//    }
    
}

