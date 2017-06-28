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
    
    @IBOutlet weak var tableView: UITableView!
    var adsInfos =  [Dictionary<String, String>]()
    var adsImages = [UIImage]()
    var notif: UNNotification?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad !")
        self.tableView.separatorColor = UIColor.clear
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        print("didReceive !")
        notif = notification
        if let liste = notification.request.content.userInfo["adsInfos"] as? [Dictionary<String, String>] {
            self.adsInfos = liste
            self.adsInfos.reverse()
        }
        print("notification.request.content.attachments.count: \(notification.request.content.attachments.count)")
        for attachement in notification.request.content.attachments {
            if attachement.url.startAccessingSecurityScopedResource(), let data = try? Data(contentsOf: attachement.url), let img = UIImage(data: data) {
                self.adsImages.append(img)
            }
            attachement.url.stopAccessingSecurityScopedResource()
        }
        self.adsImages.reverse()
        print("adsImages.count: \(self.adsImages.count)")
        
        
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection !")
        
        return adsInfos.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "licomTableViewCell", for: indexPath) as? LicomTableViewCell
        {
            let adInfos = adsInfos[indexPath.row]
            if  let price = adInfos["price"], let type = adInfos["type"], let room = adInfos["room"], let locality = adInfos["locality"], let area = adInfos["area"] {
                cell.cellImageView.image = adsImages[indexPath.row]
                cell.priceLabel.text = price
                cell.locationLabel.text = locality
                cell.typeLabel.text = type
                cell.surfaceLabel.text  = area
                cell.roomLabel.text = room
                print("return LicomTableViewCell !")
            }
            return cell
        }
        print("return UITableViewCell() !")
        return UITableViewCell()
    }
    
}

