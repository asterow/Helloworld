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

class NotificationViewController: UIViewController, UNNotificationContentExtension {
    
//    @IBOutlet var tableView: UITableView?
    //@IBOutlet var label: UILabel?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad !")

        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        print("didReceive !")

        //self.label?.text = notification.request.content.body
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellIdentifier", for: indexPath)
        
        cell.textLabel?.text = "YOHOOO"
        cell.textLabel?.textColor = UIColor.white
        
        return cell
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
