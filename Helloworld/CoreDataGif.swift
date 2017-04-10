//
//  CoreDataGif.swift
//  Helloworld
//
//  Created by Astero on 07/04/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataGif {
   
    func add(gifGiphy: GifGiphy) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        //let entity = NSEntityDescription.entity(forEntityName: "Gif", in: managedContext)!
        
        let gif = Gif(context: managedContext)
        //        let gif = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        
        //        gif.setValue(gifGiphy.id, forKey: "id")
        //        gif.setValue(gifGiphy.minUrl, forKeyPath: "minUrl")
        //        gif.setValue(gifGiphy.minNSDataImage, forKey: "minImage")
        //        gif.setValue(gifGiphy.originUrl, forKey: "originUrl")
        
        gif.id = gifGiphy.id
        gif.minUrl = gifGiphy.minUrl
        //gif.minImage = gifGiphy.minNSDataImage
        gif.originUrl = gifGiphy.originUrl
        
        if let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let imagePath = documentDirectoryURL.appendingPathComponent("\(gif.id!)_min")
            do {
                guard let minImage = gifGiphy.minNSDataImage else {
                    print("gif.minImage is nil")
                    return false
                }
                try minImage.write(to: imagePath)
                print("Saving: \(imagePath)")
            } catch {
                fatalError("Can't write image \(error)")
            }
        }
        
        // 4
        do {
            try managedContext.save()
            gifGiphy.gif = gif
            gifGiphy.loadGIF()
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteGif(gif: Gif) -> Bool {
        guard let context = gif.managedObjectContext else {
            return false
        }
        do {
            if let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                var imagePath = documentDirectoryURL.appendingPathComponent("\(gif.id!)_min")
                
                if FileManager.default.fileExists(atPath: imagePath.path) {
                    do {
                        try FileManager.default.removeItem(at: imagePath)
                        print("Delete: \(imagePath)")
                    } catch {
                        print("Can't delete image \(error)")
                    }
                }
                else {
                    print("Can't delete minImage: \(imagePath)")
                }
                imagePath = documentDirectoryURL.appendingPathComponent("\(gif.id!)_max")
                if FileManager.default.fileExists(atPath: imagePath.path) {
                    do {
                        try FileManager.default.removeItem(at: imagePath)
                        print("Delete: \(imagePath)")
                    } catch {
                        print("Can't delete image \(error)")
                    }
                }
                else {
                    print("Can't delete originImage: \(imagePath)")
                }
                context.delete(gif)
                try context.save()
            }
            return true
        } catch let error as NSError {
            print("deleteGif Error: \(error)")
            return false
        }
    }

    func fetchGif() -> [Gif]?{
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<Gif>(entityName: "Gif")
        
        //3
        do {
            var arrayGif = try managedContext.fetch(fetchRequest)
            arrayGif.reverse()
            print("arrayGifCount: \(arrayGif.count)")
            return arrayGif
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }


}
