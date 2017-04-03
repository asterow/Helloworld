//
//  GiphyService.swift
//  Helloworld
//
//  Created by Astero on 24/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import Foundation

class GiphyService {
    
    init() {
        print("Starting GiphyService")
    }
    
    func getRandomGif(keyWord: String, callback:@escaping ((GifGiphy) -> Void)) {
        var result = keyWord.folding(options: .diacriticInsensitive, locale: nil)
        result = result.lowercased()
        result = result.trimmingCharacters(in: CharacterSet(charactersIn: "0123456789abcdefghijklmnopqrstuvwxyz ").inverted)
        result = result.replacingOccurrences(of: " ", with: "+")
        print("Result: \(result)")
        let url = URL(string: "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=\(result)")!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            do {
                guard let thelistData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any] else {
                    print("GUARD ! thelistData")
                    return
                }
                let data = thelistData["data"] as! [String:Any]
                print(data["image_url"] as! String)
                let gifGiphy = GifGiphy(id: data["id"] as! String, minUrl: data["fixed_width_downsampled_url"] as! String, originUrl: data["image_url"] as! String)
                callback(gifGiphy)
            } catch let error as NSError {
                print(error)
            }
            
            
        })
        task.resume()
    }
}
