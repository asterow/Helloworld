//
//  MapViewController.swift
//  Helloworld
//
//  Created by Astero on 11/04/2017.
//  Copyright © 2017 Astero. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var arrayGifGiphy = [GifGiphy]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
//        let capAntibes = CLLocationCoordinate2D(latitude: 43.545057, longitude: 7.131186)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = capAntibes
//        annotation.title = "Cap d'Antibes"
//        annotation.subtitle = "Dream Land"
//        mapView.addAnnotation(annotation)
        var i = 0
        for gif in self.arrayGifGiphy {
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            guard let image = gif.minImage else {
                return
            }
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            gif.mapImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            guard let location = gif.location else {
                return
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = gif.id
            annotation.subtitle = i.description
            i += 1
            mapView.addAnnotation(annotation)
            
            // print("GIFGIPHY: id = \(gif.id) - location = \(gif.location!)")
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
//        let capAntibes = CLLocationCoordinate2D(latitude: 43.545057, longitude: 7.131186)
//        mapView.setCenter(capAntibes, animated: true)
//        mapView.setRegion(MKCoordinateRegionMakeWithDistance(capAntibes, 2300, 2300), animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension MapViewController: MKMapViewDelegate {
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: "pinview") {
            view.annotation = annotation
            print("reuse!!")
            return view
        }
//        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pinview")
        let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "pinview")
        guard let subtitle = annotation.subtitle else {
            return nil
        }
        guard let index = Int(subtitle!) else {
            return nil
        }
        view.image = arrayGifGiphy[index].mapImage
//        view.pinTintColor = UIColor.green
        view.canShowCallout = true
        return view
    }
}
