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
   
    func add(gifGiphy: GifGiphy) -> Gif? {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return nil
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
        gif.minImage = gifGiphy.minNSDataImage
        gif.originUrl = gifGiphy.originUrl
        
        
        // 4
        do {
            try managedContext.save()
            return gif
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func deleteGif(gif: Gif) -> Bool {
        guard let context = gif.managedObjectContext else {
            return false
        }
        context.delete(gif)
        do {
            try context.save()
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
