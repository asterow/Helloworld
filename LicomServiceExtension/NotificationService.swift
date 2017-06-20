//
//  NotificationService.swift
//  LicomServiceExtension
//
//  Created by frederic.THEAULT on 20/06/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UserNotifications
import SwiftSoup
import Alamofire

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            if bestAttemptContent.categoryIdentifier == "LICOM_CATEGORY" {
//                bestAttemptContent.body = " "
                
                
                // recuperer la liste de biens dispos
                guard let contents = bestAttemptContent.userInfo["content"] as? [[String : Any]]  else {
                    return contentHandler(bestAttemptContent)
                }
                
                for (index, content) in contents.enumerated() {
                    if let id = content["id"] {
                        print("id[\(index)] = \(id)")
                    }
                }
                if contents.count == 1 {
                    bestAttemptContent.title = "1 Nouveau bien disponible"
                }
                else {
                    bestAttemptContent.title = "\(contents.count) Nouveaux biens disponibles"

                }

                // recuperer id du bien et creer url de la loc

                guard let firstId = contents[0]["id"] as? String else {
                    return contentHandler(bestAttemptContent)
                }
                guard let firstUrl = URL(string: "http://www.logic-immo.com/detail-location-\(firstId).htm") else {
                    return contentHandler(bestAttemptContent)
                }
                print("firstUrl = \(firstUrl.absoluteString)")
//                scrapeWebPage(url: firstUrl.absoluteString)
                
                Alamofire.request(firstUrl.absoluteString).responseString { response in
                    print("\(response.result.isSuccess)")
                    if let html = response.result.value {
                        //                self.parseHTML(html: html)
                        //print("SCRAPED_PAGE = \(html)")
                        do{
                            
                            let doc: Document = try! SwiftSoup.parse(html)
                            let title = try! doc.select("title").text()
                            let imageUrl = try! doc.select("#offer_pictures_main").attr("src")
                            bestAttemptContent.body = title
                            print("Image URL =\(imageUrl)")
                            let imageURL = URL(string: imageUrl)
                            self.downloadWithURL(url: imageURL!, completion: { (complete) in
                                if complete == true {
                                    print("true")
                                }
                                
                                contentHandler(bestAttemptContent)
                            })
                            
                            
                        }catch Exception.Error(let type, let message){
                            print(message)
                        }catch{
                            print("error")
                        }

                        
                    }
                }
                
                
//                getWebPage(url: firstUrl, completion: {(dataString) in
//                    guard let dataString = dataString else {
//                        return
//                    }
////                    print("getWebPage complete: \(dataString)")
//                    do{
//                        
//                        let doc: Document = try! SwiftSoup.parse(dataString)
//                        if let linkImage = try! doc.select("title").first() {
////                            let imageURL = try! linkImage.attr("src")
//                            let title = try! linkImage.text()
//                            bestAttemptContent.body = title
//                            print("linkImageUrl = \(title)")
//                        }
//
//                    }catch Exception.Error(let type, let message){
//                        print(message)
//                    }catch{
//                        print("error")
//                    }
//                })

                
                // faire un GET sur cette url
                
                // parser le HTML avec SwiftSoup
                    // recup description
                    // rrecup image
                
                
                // Telecharger Image et inclure dans la notif
                
                
                
//                guard let imageUrl = bestAttemptContent.userInfo["attachment"] as? String else {
//                    return contentHandler(bestAttemptContent)
//                }
//                let url = URL(string: imageUrl)
//                downloadWithURL(url: url!, completion: { (complete) in
//                    if complete == true {
//                        print("true")
//                    }
//                    
//                    contentHandler(bestAttemptContent)
//                })
//                print("Image URL = \(imageUrl)")
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
    
    private func scrapeWebPage(url: String) -> Void {
        Alamofire.request(url).responseString { response in
            print("\(response.result.isSuccess)")
            if let html = response.result.value {
//                self.parseHTML(html: html)
                print("SCRAPED_PAGE = \(html)")
            }
        }
    }
    
    private func getWebPage(url: URL, completion: @escaping (String?) -> Void) {
        do {
            let directURL = try String.init(contentsOf: url, encoding: .utf8)
            //print("directURL = \(directURL)")
        }
        catch let error as NSError {
            print(error)
        }
//        let task = URLSession.shared.
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard error == nil else {
                print("getWebPage error: \(error!)" )
                completion(nil)
                return
            }
            guard let data = data else {
                print("getWebPage data is nil" )
                completion(nil)
                return
            }
            guard let dataString = String(data: data, encoding: .utf8) else {
                completion(nil)
                return
            }
            completion(dataString)
            
        }
        task.resume()

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
