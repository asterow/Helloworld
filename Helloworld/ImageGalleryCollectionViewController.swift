//
//  ImageGalleryCollectionViewController.swift
//  Helloworld
//
//  Created by Astero on 23/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit

private let reuseIdentifier = "imageCell"

class ImageGalleryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
//    var arrayUIImage = [UIImage]()
//    var arrayOriginalUIImage = [UIImage]()
    var arrayGifGiphy = [GifGiphy]()
    var firstCell: SearchImageCollectionViewCell? = nil
    let loadingQueue = DispatchQueue(label: "com.astero.queue.loadingQueue", qos: .userInteractive)
    let gifService = GiphyService()


   
    
    override func viewDidLoad() {
        super.viewDidLoad()

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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return arrayGifGiphy.count + 1
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
    
    func onClickGifButton() {
        firstCell?.searchGifTextField.resignFirstResponder()
        let apiResponseCallBack = {
            (gifGiphy: GifGiphy) in
            self.loadingQueue.async {
//            DispatchQueue.global().async{
                guard let imgUrl = URL(string: gifGiphy.minUrl) else {
                    print("GUARD: imgURL")
                    return
                }
                guard let data = try? Data(contentsOf: imgUrl) else {
                    print("GUARD: data")
                    return

                }
                self.firstCell?.gifGiphy = gifGiphy
                self.firstCell?.gifGiphy?.minImage = UIImage.gif(data: data)
                //self.arrayGifGiphy.append(gifGiphy)
                print("Image downloaded")
                DispatchQueue.main.async {
                    //self.collectionView?.reloadData()
                    self.firstCell?.imageView.image = nil
                    self.firstCell?.imageView.image = self.firstCell?.gifGiphy?.minImage
                }
            }
        }
        gifService.getRandomGif(keyWord: firstCell?.searchGifTextField.text ?? "", callback: apiResponseCallBack)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

//        print("indexPath: \(indexPath) - item: \(indexPath.item)")

        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath)  as! SearchImageCollectionViewCell
            // Define closure to perform action on add button #1stWayToActionInCell
            cell.closureActionAddGiffButton = {
                // check if image already exist in CollectionVieW
                for gif in self.arrayGifGiphy {
                    if gif.id == cell.gifGiphy?.id {
                        return
                    }
                }
                self.arrayGifGiphy.insert(cell.gifGiphy!, at: 0)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
            // Add target to perform action on search giphy button #2ndWayToActionInCell
            cell.gifButton.addTarget(self, action: #selector(onClickGifButton), for: UIControlEvents.touchUpInside)
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
            self.arrayGifGiphy[row - 1].detailImageViewController = detailImageViewController
            if self.arrayGifGiphy[row - 1].originImage == nil {
                self.loadingQueue.async {
                    let imgUrl = URL(string: self.arrayGifGiphy[row - 1].originUrl)
                    let data = try? Data(contentsOf: imgUrl!)
                    self.arrayGifGiphy[row - 1].originImage = UIImage.gif(data: data!)
                    DispatchQueue.main.async {
                        self.arrayGifGiphy[row - 1].detailImageViewController?.reloadOriginalImage()
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
