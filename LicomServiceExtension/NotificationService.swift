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
        print("### didReceive: BEGIN ###")
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            if bestAttemptContent.categoryIdentifier == "LICOM_CATEGORY" {
                // recuperer la liste de biens dispos
                guard let contents = bestAttemptContent.userInfo["content"] as? [[String : Any]]  else {
                    print("didReceive: GUARD contents")
                    return contentHandler(bestAttemptContent)
                }
                
                bestAttemptContent.title = "1 Nouveau bien disponible !"
                if contents.count > 0 {
                    bestAttemptContent.title = "\(contents.count) Nouveaux biens disponibles !"
                }
                
                // recuperer id du 1er bien et creer url de la loc
                guard let firstId = contents[0]["id"] as? String,
                    let webUrl = URL(string: "http://www.logic-immo.com/detail-location-\(firstId).htm") else {
                        return contentHandler(bestAttemptContent)
                }
                print("webUrl: \(webUrl.absoluteString)")
                // faire un GET sur cette url
                Alamofire.request(webUrl.absoluteString).responseString { response in
                    // parser le HTML avec Kanna
                    if let html = response.result.value, let doc = HTML(html: html, encoding: .utf8) {
                        print("web page scraped, size: \(html.characters.count)")
                        // recup description
                        guard let titleNode = doc.at_css("title"),
                            let description = titleNode.content?.replacingOccurrences(of: " - Logic-immo.com", with: "").trimmingCharacters(in: .whitespaces) else {
                                return contentHandler(bestAttemptContent)
                        }
                        bestAttemptContent.body = description
                        print("description: \(description)")
                        if let priceNode = doc.at_css(".main-price"), let price = priceNode.content?.trimmingCharacters(in: .whitespacesAndNewlines),
                            let localityNode = doc.at_css(".locality > span"), let locality = localityNode.content?.trimmingCharacters(in: .whitespacesAndNewlines),
                            let areaNode = doc.at_css(".area"), let area = areaNode.content?.trimmingCharacters(in: .whitespacesAndNewlines),
                            let roomNode = doc.at_css(".offer-rooms"), let room = roomNode.content?.trimmingCharacters(in: .whitespacesAndNewlines),
                            let typeNode = doc.at_css(".type"), let type = typeNode.content?.trimmingCharacters(in: .whitespacesAndNewlines) {
                            print("type: \(type)")
                            print("room: \(room)")
                            print("area: \(area)")
                            print("locality: \(locality)")
                            print("price: \(price)")
                            
                            var adsInfos = [["type": type, "room": room, "area": area, "locality": locality, "price": price]]
                            adsInfos.append(["type": type, "room": room, "area": area, "locality": locality, "price": price])
                            
                            self.bestAttemptContent?.userInfo.updateValue(adsInfos, forKey: "adsInfos")
                            
//                            print("self.bestAttemptContent?.userInfo.count: \(self.bestAttemptContent?.userInfo.description)")
                        }
                        // recup image
                        guard let img = doc.at_css("#offer_pictures_main"),
                            let imgSrc = img["src"],
                            let imgUrl = URL(string: imgSrc) else {
                                return contentHandler(bestAttemptContent)
                        }
                        // Telecharger Image et inclure dans la notif
                        self.downloadWithURL(url: imgUrl, completion: { (complete) in
                            if complete == true {
                                print("### Completion: true ###")
                            } else {
                                print("### Completion: false ###")
                            }
                            contentHandler(bestAttemptContent)
                        })
                    }
                }
            }
            else {
                contentHandler(bestAttemptContent)
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
        let imgRemoteUrl = url.absoluteString
        print("imgRemoteUrl: \(imgRemoteUrl)")
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            guard let downloadedUrl = downloadedUrl else {
                completion(false)
                return
            }
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let imgFileUrl = URL(fileURLWithPath: path).appendingPathComponent("pic.jpg")
            print("downloadedFileUrl: \(downloadedUrl)")
            print("imgFileUrl: \(imgFileUrl)")
            try? FileManager.default.moveItem(at: downloadedUrl, to: imgFileUrl)
            do {
                let attachment = try UNNotificationAttachment(identifier: imgRemoteUrl, url: imgFileUrl, options: nil)
                defer {
                    self.bestAttemptContent?.attachments = [attachment]
                    completion(true)
                }
            }
            catch {
                completion(false)
            }
        }
        task.resume()
    }
    
}
