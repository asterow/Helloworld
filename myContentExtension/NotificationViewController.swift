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
    var adsInfos =  [Dictionary<String, String>]()
    var adsImages = [UIImage]()
    var notif: UNNotification?
//    var adsInfos :  [Dictionary<String, String>]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad !")
        self.tableView.separatorColor = UIColor.clear
//        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        print("didReceive !")
        notif = notification
        if let liste = notification.request.content.userInfo["adsInfos"] as? [Dictionary<String, String>] {
            self.adsInfos = liste
        }
        
        for attachement in notification.request.content.attachments {
            if attachement.url.startAccessingSecurityScopedResource(), let data = try? Data(contentsOf: attachement.url), let img = UIImage(data: data) {
                self.adsImages.append(img)
            }
            attachement.url.stopAccessingSecurityScopedResource()
        }
        
        
//        for (index, adInfos) in adsInfos.enumerated() {
//            if let content = notif?.request.content {
//                let attachement = content.attachments[0]
//                print("startAccessingSecurityScopedResource")
//                if attachement.url.startAccessingSecurityScopedResource() {
//                    if let data = try? Data(contentsOf: attachement.url) {
//                        adsImages.append(UIImage(data: data)!)
//                    }
//                    attachement.url.stopAccessingSecurityScopedResource()
//                }
//            }
//        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection !")
  
        return adsInfos.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return CGFloat.ini
//        return CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
//
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "licomTableViewCell", for: indexPath) as? LicomTableViewCell
        {
//            if let adInfos = adsInfos[indexPath.row] {
//                
//            }
            
            let adInfos = adsInfos[indexPath.row]
            if  let price = adInfos["price"], let type = adInfos["type"], let room = adInfos["room"], let locality = adInfos["locality"], let area = adInfos["area"] {
                cell.cellImageView.image = adsImages[0]
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

