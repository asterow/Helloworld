//
//  NotificationService.swift
//  LicomServiceExtension
//
//  Created by frederic.THEAULT on 20/06/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UserNotifications
import Alamofire
import Kanna


class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        print("didReceive: STARTING !")
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            if bestAttemptContent.categoryIdentifier == "LICOM_CATEGORY" {
                // recuperer la liste de biens dispos
                guard let contents = bestAttemptContent.userInfo["content"] as? [[String : Any]]  else {
                    print("didReceive: GUARD contents")
                    return contentHandler(bestAttemptContent)
                }
//                for (index, content) in contents.enumerated() {
//                    if let id = content["id"] {
//                        print("id[\(index)] = \(id)")
//                    }
//                }
                if contents.count == 1 {
                    bestAttemptContent.title = "1 Nouveau bien disponible !"
                }
                else {
                    bestAttemptContent.title = "\(contents.count) Nouveaux biens disponibles !"
                }
                
                // recuperer id du bien et creer url de la loc
                guard let firstId = contents[0]["id"] as? String else {
                    return contentHandler(bestAttemptContent)
                }
                guard let firstUrl = URL(string: "http://www.logic-immo.com/detail-location-\(firstId).htm") else {
                    return contentHandler(bestAttemptContent)
                }
                print("firstUrl = \(firstUrl.absoluteString)")
                // faire un GET sur cette url
                Alamofire.request(firstUrl.absoluteString).responseString { response in
                    print("response.result.isSuccess: \(response.result.isSuccess)")
                    if let html = response.result.value, let doc = HTML(html: html, encoding: .utf8) {
                        // parser le HTML avec Kanna
                        // recup description
                        print("SCRAPED_PAGE size = \(html.characters.count)\n")
                        let title = doc.at_css("title")?.content?.replacingOccurrences(of: " - Logic-immo.com", with: "").trimmingCharacters(in: .whitespaces)
                        bestAttemptContent.body = title!
                        print("title:\(title!)")
                        // recup image
                        let img = doc.at_css("#offer_pictures_main")
                        let imgSrc = img?["src"]
                        let imgUrl = URL(string: imgSrc!)
                        print("Kanna img src = \(imgUrl!)")
                        // Telecharger Image et inclure dans la notif
                        self.downloadWithURL(url: imgUrl!, completion: { (complete) in
                            if complete == true {
                                print("true")
                            }
                            contentHandler(bestAttemptContent)
                        })
                    }
                }
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        print("serviceExtensionTimeWillExpire()")
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    private func downloadWithURL(url: URL, completion: @escaping (Bool) -> Void) {
        print("url absolute = \(url.absoluteString)")
        let remoteUrl = url.absoluteString
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            guard let downloadedUrl = downloadedUrl else {
                completion(false)
                return
            }
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            var url = URL(fileURLWithPath: path)
            url = url.appendingPathComponent("pic.jpg")
            print("URL = \(url)")
            try? FileManager.default.moveItem(at: downloadedUrl, to: url)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: remoteUrl, url: url, options: nil)
                defer {
                    self.bestAttemptContent?.attachments = [attachment]
                    print("attachment added, identifier = \(remoteUrl)")
                    completion(true)
                }
            }
            catch {
                completion(true)
            }
        }
        task.resume()
    }
    
}
