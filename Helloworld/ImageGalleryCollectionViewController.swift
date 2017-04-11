//
//  ImageGalleryCollectionViewController.swift
//  Helloworld
//
//  Created by Astero on 23/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
//import MapKit


private let reuseIdentifier = "imageCell"

class ImageGalleryCollectionViewController: UICollectionViewController {
    
    
    
    var arrayGifGiphy = [GifGiphy]()
    
    var firstCell: SearchImageCollectionViewCell? = nil
    var lastLocation: CLLocationCoordinate2D? = nil
    
    let loadingQueue = DispatchQueue(label: "com.astero.queue.loadingQueue", qos: .userInteractive)
    let gifService = GiphyService()
    
    var coreDataGif = CoreDataGif()
    
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        DispatchQueue.main.async {
            self.addLongPressGestureToDeleteGif()

            guard let arrayGif = self.coreDataGif.fetchGif() else {
                return
            }
            
            for gif in arrayGif {
                let gifGiphy = GifGiphy(gif: gif)
                self.arrayGifGiphy.append(gifGiphy)
            }
            
            if self.arrayGifGiphy.count > 0 {
                var indexes = [IndexPath]()
                for  i in 0 ..<  self.arrayGifGiphy.count {
                    indexes.append(IndexPath(row: i + 1, section: 0))
                }
                self.collectionView?.insertItems(at: indexes)
            }
            self.startLocationManager()
        }
        
        
        //        for gif in arrayGifEntity {
        //
        //        }
        
        //        for i in 0 ..< 1000 {
        //            print("iteration: \(i)")
        //            onClickGifButton()
        //        }
        
        //        let queue1 = DispatchQueue(label: "com.astero.maqueue.1", qos: .background)
        //        let queue2 = DispatchQueue(label: "com.astero.maqueue.2", qos: .utility)
        //
        //        queue2.async {
        //            for i in 0..<100 {
        //                print("2 - \(i)")
        //            }
        //        }
        //        queue1.async {
        //            for i in 0..<1000 {
        //                print("1 - \(i)")
        //            }
        //
        //        }
        //        queue1.async {
        //            for i in 0..<1000 {
        //                print("1.1 - \(i)")
        //            }
        //            task.resume()
        //
        //        }
        //        DispatchQueue.main.async {
        //            print("lol")
        //        }
        
        //        var request = URLRequest(url: url)
        //        request.httpMethod = "POST"
        //        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //        let body = "{\"name\":\"tata\",\"desc\":\"tata Desc\"}"
        ////        let body = "name=toto&desc=totoDesc"
        //
        //        request.httpBody = body.data(using: String.Encoding.utf8)
        //        let postTask = session.dataTask(with: request, completionHandler: {
        //            (data, response, error) in
        //            guard error == nil else {
        //                print(error.debugDescription)
        //                return
        //            }
        //        })
        
        
        //        postTask.resume()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(SearchImageCollectionViewCell.self, forCellWithReuseIdentifier: "firstCell")
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("didReceiveMemoryWarning WARNIIIIINNNNNG !!!!")
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func changeNavTitle(_ title: String?) {
        DispatchQueue.main.async {
            guard let title = title else {
                self.title = ""
                return
            }
            self.title = title
        }
    }
    
    func onClickGifButton() {
        firstCell?.searchGifTextField.resignFirstResponder()
        self.changeNavTitle("Downloading")
        gifService.getRandomGif(keyWord: firstCell?.searchGifTextField.text ?? "") {
            (gifGiphy: GifGiphy?) in
            self.loadingQueue.async {
                //            DispatchQueue.global().async{
                guard let gifGiphy = gifGiphy else {
                    self.changeNavTitle("No internet connexion")
                    return
                }
                guard let imgUrl = URL(string: gifGiphy.minUrl) else {
                    self.changeNavTitle("No internet connexion")
                    print("GUARD: imgURL")
                    return
                }
                guard let data = NSData(contentsOf: imgUrl) else {
                    self.changeNavTitle("No internet connexion")
                    print("GUARD: data")
                    return
                }
                
                self.changeNavTitle("")
                self.firstCell?.gifGiphy = gifGiphy
                self.firstCell?.gifGiphy?.minNSDataImage = data
                self.firstCell?.gifGiphy?.minImage = UIImage.gif(data: data as Data)
                print("Image downloaded")
                DispatchQueue.main.async {
                    self.firstCell?.imageView.image = nil
                    self.firstCell?.imageView.image = self.firstCell?.gifGiphy?.minImage
                }
            }
        }
        
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayGifGiphy.count + 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
        }
        else {
            return CGSize.init(width: 180, height: 180)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath)  as! SearchImageCollectionViewCell
            // Define closure to perform action on add button #1stWayToActionInCell
            cell.closureActionAddGiffButton = {
                guard let gifGiphy = cell.gifGiphy else {
                    print("Gif's not loaded")
                    return
                }
                // check if image already exist in CollectionVieW
                for gif in self.arrayGifGiphy {
                    if gif.id == gifGiphy.id {
                        return
                    }
                }
//                guard let location = self.lastLocation else {
//                    print("location is nil")
//                    return
//                }
                if let location = self.lastLocation {
                    gifGiphy.location = location
                }
                guard self.coreDataGif.add(gifGiphy: gifGiphy) else {
                    print("coreDataGif.add return false")
                    return
                }
                self.arrayGifGiphy.insert(gifGiphy, at: 0)
                DispatchQueue.main.async {
                    var indexs = [IndexPath]()
                    indexs.append(IndexPath(row: 1, section: 0))
                    self.collectionView?.insertItems(at: indexs)
                }
            }
            // Add target to perform action on search giphy button #2ndWayToActionInCell
            cell.gifButton.addTarget(self, action: #selector(onClickGifButton), for: .touchUpInside)
            let image = cell.imageView.image
            cell.imageView.image = nil
            cell.imageView.image = image
            firstCell = cell
            return cell
        }
        else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)  as! ImageGalleryCollectionViewCell
            DispatchQueue.main.async {
                cell.imageView.image = nil
                cell.imageView.image = self.arrayGifGiphy[indexPath.row - 1].minImage
            }
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetailImage" {
            guard let cell = sender as? ImageGalleryCollectionViewCell else {
                print("no selection while preparing segue: quoteDetailSegue")
                return
            }
            guard let detailImageViewController = segue.destination as? DetailImageViewController else {
                print("cant cast segue.destination to DetailImageViewController")
                return
            }
            var indexPath = collectionView?.indexPath(for: cell)
            let row = indexPath!.row
            print("load image: \(indexPath!.row)")
            detailImageViewController.gifGiphy = self.arrayGifGiphy[row - 1]
            if detailImageViewController.gifGiphy?.originImage == nil {
                self.loadingQueue.async {
                    let imgUrl = URL(string: detailImageViewController.gifGiphy!.originUrl)
                    guard let data = NSData(contentsOf: imgUrl!) else {
                        print("Can't download imgUrl: \(imgUrl)")
                        return
                    }
                    if let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let imagePath = documentDirectoryURL.appendingPathComponent("\(detailImageViewController.gifGiphy!.id)_max")
                        do {
                            try data.write(to: imagePath)
                            print("Saving: \(imagePath)")
                        } catch {
                            fatalError("Can't write image \(error)")
                        }
                    }
                    detailImageViewController.gifGiphy?.originImage = UIImage.gif(data: data as Data)
                    DispatchQueue.main.async {
                        detailImageViewController.reloadOriginalImage()
                        print("OriginImage downloaded: Reloading")
                    }
                }
            }
            
        }
        else if segue.identifier == "mapSegue" {
            guard let mapViewController = segue.destination as? MapViewController else {
                print("Cant cast segue.destination to MapViewController")
                return
            }
            mapViewController.arrayGifGiphy = arrayGifGiphy.filter { $0.location != nil }
            print("mapSegue")
        }
    }
    
}


extension ImageGalleryCollectionViewController: UIGestureRecognizerDelegate {
    
    func addLongPressGestureToDeleteGif() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView?.addGestureRecognizer(lpgr)
    }
    
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != .began {
            return
        }
        
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: p)
        
        if let index = indexPath, index.row != 0 {
            //            var cell = self.collectionView?.cellForItem(at: index)
            print(index.row)
            let alertController = UIAlertController(title: nil, message: "Delete this GIF ?", preferredStyle: .actionSheet)
            alertController.popoverPresentationController?.sourceView = collectionView
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            }
            alertController.addAction(cancelAction)
            
            
            
            let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                guard let gif = self.arrayGifGiphy[index.row - 1].gif else {
                    print("gif is nil before delete")
                    return
                }
                if self.coreDataGif.deleteGif(gif: gif) {
                    //                    self.arrayGif.remove(at: index.row - 1)
                    self.arrayGifGiphy.remove(at: index.row - 1)
                    DispatchQueue.main.async {
                        var indexPaths = [IndexPath]()
                        indexPaths.append(index)
                        self.collectionView?.deleteItems(at: indexPaths)
                    }
                }
                //print(action)
            }
            alertController.addAction(destroyAction)
            
            //DispatchQueue.main.async {
            self.present(alertController, animated: true) {
                // ...
            }
            //}
            
            
        } else {
            print("Could not find index path")
        }
    }
}

extension ImageGalleryCollectionViewController: CLLocationManagerDelegate {
    func startLocationManager() {
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("locationServices: Enabled - desiredAccuracy: \(locationManager.desiredAccuracy)")
            self.locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        self.lastLocation = locValue
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
}


extension ImageGalleryCollectionViewController: UICollectionViewDelegateFlowLayout {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
}


