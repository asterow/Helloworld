//
//  ImageGalleryCollectionViewController.swift
//  Helloworld
//
//  Created by Astero on 23/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "imageCell"

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    

    var arrayGif = [Gif]()
    
    var firstCell: SearchImageCollectionViewCell? = nil
    let loadingQueue = DispatchQueue(label: "com.astero.queue.loadingQueue", qos: .userInteractive)
    let gifService = GiphyService()

    var coreDataGif = CoreDataGif()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
        
        DispatchQueue.main.async {
            guard let arrayGif = self.coreDataGif.fetchGif() else {
                return
            }
            self.arrayGif = arrayGif
            var indexes = [IndexPath]()
            for  i in 0 ..<  arrayGif.count {
                indexes.append(IndexPath(row: i + 1, section: 0))
            }
            self.collectionView?.insertItems(at: indexes)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != .began {
            return
        }
        
        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: p)
        
        if let index = indexPath {
//            var cell = self.collectionView?.cellForItem(at: index)
            print(index.row)
            let alertController = UIAlertController(title: nil, message: "Delete this GIF ?", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            }
            alertController.addAction(cancelAction)
            
            
            
            let destroyAction = UIAlertAction(title: "Delete", style: .destructive) { action in
                if self.coreDataGif.deleteGif(gif: self.arrayGif[index.row - 1]) {
                    self.arrayGif.remove(at: index.row - 1)
                    DispatchQueue.main.async {
                        var indexPaths = [IndexPath]()
                        indexPaths.append(index)
                        self.collectionView?.deleteItems(at: indexPaths)
                    }
                }
                print(action)
            }
            alertController.addAction(destroyAction)
            
            self.present(alertController, animated: true) {
                // ...
            }
            
        } else {
            print("Could not find index path")
        }
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
        return arrayGif.count + 1
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
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
                for gif in self.arrayGif {
                    if gif.id == gifGiphy.id {
                        return
                    }
                }
                guard let gif = self.coreDataGif.add(gifGiphy: gifGiphy) else {
                    print("coreDataGif.add return nil")
                    return
                }
                self.arrayGif.insert(gif, at: 0)
//                self.arrayGif = self.coreDataGif.add(gifGiphy: gifGiphy)!
                DispatchQueue.main.async {
                    var indexs = [IndexPath]()
                    indexs.append(IndexPath(row: 1, section: 0))
                    self.collectionView?.insertItems(at: indexs)
//                    self.collectionView?.reloadData()
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
                cell.imageView.image = UIImage.gif(data: self.arrayGif[indexPath.row - 1].minImage as! Data)
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
            detailImageViewController.gif = self.arrayGif[row - 1]
            if detailImageViewController.gif?.originImage == nil {
                self.loadingQueue.async {
                    let imgUrl = URL(string: detailImageViewController.gif!.originUrl!)
                    let data = NSData(contentsOf: imgUrl!)
                    detailImageViewController.gif?.originImage = data
                    do {
                        try detailImageViewController.gif?.managedObjectContext?.save()

                    } catch let error as NSError {
                        print("Could not save. \(error), \(error.userInfo)")
                    }
                    DispatchQueue.main.async {
                        detailImageViewController.reloadOriginalImage()
                        print("OriginImage downloaded: Reloading")
                    }
                }
            }

        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
