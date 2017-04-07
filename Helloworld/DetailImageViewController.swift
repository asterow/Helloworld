//
//  DetailImageViewController.swift
//  Helloworld
//
//  Created by Astero on 23/03/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit
import CoreData

class DetailImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var scale: CGFloat = 1
    let maxScale: CGFloat = 10
    let minScale: CGFloat = 1
    
    
    @IBAction func moveImage(_ sender: UIPanGestureRecognizer) {

        //print("first: \((self.imageView.center.x ) + (self.imageView.bounds.width / 2 * scale)) second: \(self.imageView.bounds.width * scale / 2)")
        let translation = sender.translation(in: self.imageView)
        let translationX = translation.x * scale
        let translationY = translation.y * scale
        let halfImageWidth = self.imageView.bounds.width / 2 * scale
        let halfImageHeight = self.imageView.bounds.height / 2 * scale
        let navBarheight: CGFloat = UIScreen.main.bounds.height - self.imageView.bounds.height
        //print("image Height: \(UIScreen.main.bounds.height)")
        //print("navbarH: \(navBarheight)")
       // print("image Height: \(self.imageView.bounds.)")
        if let view = sender.view {
            var x = view.center.x
            var y = view.center.y
//            if (self.imageView.center.x + translationX) < halfImageWidth && (self.imageView.center.x + translationX) > self.imageView.bounds.width * (2 - scale) / 2 {
            
            

            
            if (self.imageView.center.x + translationX) < halfImageWidth && (self.imageView.center.x + translationX) + halfImageWidth > self.imageView.bounds.width {
                x += translationX
            }
            else {
                if (self.imageView.center.x + translationX) > halfImageWidth {
                    print("1")
                }
                if (self.imageView.center.x + translationX) + halfImageWidth < self.imageView.bounds.width {
                    print("2")
                }
            }
            if (self.imageView.center.y + translationY) < halfImageHeight + navBarheight && (self.imageView.center.y + translationY) + halfImageHeight > self.imageView.bounds.height + navBarheight{
                y += translationY
            }
            else {
                if (self.imageView.center.y + translationY) > halfImageHeight + navBarheight {
                    print("3")
                }
                if (self.imageView.center.y + translationY) + halfImageHeight < self.imageView.bounds.height + navBarheight {
                    print("4")
                }
            }

            view.center = CGPoint(x: x, y: y)
        }
        //print("imageView.center after: \(self.imageView.center)")

        sender.setTranslation(CGPoint.zero, in: self.imageView)
        
//        //sender.setTranslation(lol, in: self.imageView)
//
////        var frame = imageView.frame
////        
////        frame.origin.x += lol.x
////        frame.origin.y += lol.y
////        
//        imageView.transform = CGAffineTransform(translationX: lol.x, y: lol.y)
//        imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//        //sender.setTranslation(sender.translation(in: imageView), in: imageView)
//        print("sender.translation: \(lol)")

        
        
        
    }
    @IBAction func scaleImage(_ sender: UIPinchGestureRecognizer) {
//        imageView.contentScaleFactor
        
//        imageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
//        sender.scale = 1
        
        if sender.state == .began {
            sender.scale = scale
        }
        else {
        imageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
        }
        if sender.state == .ended {
            if sender.scale < minScale {
                sender.scale = minScale
                imageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
            }
            else if sender.scale > maxScale {
                sender.scale = maxScale
                imageView.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
            }
            scale = sender.scale
            let halfImageWidth = self.imageView.bounds.width / 2 * scale
            let halfImageHeight = self.imageView.bounds.height / 2 * scale
            let navBarheight: CGFloat = UIScreen.main.bounds.height - self.imageView.bounds.height

            if (self.imageView.center.x ) + halfImageWidth < self.imageView.bounds.width {
                imageView.center.x = self.imageView.bounds.width - halfImageWidth
            }
            if (self.imageView.center.x ) - halfImageWidth > 0 {
                imageView.center.x = halfImageWidth
            }
            if (self.imageView.center.y ) + halfImageHeight < self.imageView.bounds.height + navBarheight {
                imageView.center.y = self.imageView.bounds.height - halfImageHeight + navBarheight
                print("1Y")

            }
            if (self.imageView.center.y ) - halfImageHeight  > 0 {
                print("2Y")
                imageView.center.y = halfImageHeight + navBarheight

            }
            print ("sender.scale: \(sender.scale), sender.state: \(sender.state.hashValue)")
        }
    }
    //var image: UIImage? = nil
    var gifGiphy: GifGiphy?
    var gif: Gif?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if gifGiphy?.originImage != nil {
//            imageView.image = gifGiphy?.originImage
//        }
//        else {
//            imageView.image = gifGiphy?.minImage
//        }

        DispatchQueue.main.async {
            self.imageView.alpha = 0.0

            if self.gif?.originImage != nil {
                self.imageView.image = UIImage.gif(data: self.gif?.originImage as! Data)
            }
            else {
                self.imageView.image = UIImage.gif(data: self.gif?.minImage as! Data)
            }
            UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut , animations: {
                self.imageView.alpha = 1.0
            }, completion: nil)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadOriginalImage() {
//        if gifGiphy?.originImage != nil {
//            imageView.image = gifGiphy?.originImage
//        }
//        else {
//            imageView.image = gifGiphy?.minImage
//        }
        
    
        DispatchQueue.main.async {
            if self.gif?.originImage != nil {
                self.imageView.image = UIImage.gif(data: self.gif?.originImage as! Data)
            }
            else {
                self.imageView.image = UIImage.gif(data: self.gif?.minImage as! Data)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
