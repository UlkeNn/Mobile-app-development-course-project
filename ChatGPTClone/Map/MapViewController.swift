//
//  MapViewController.swift
//  ChatGPTClone
//
//  Created by Ulgen on 10.06.2025.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //The accuracy of the location data that your app wants to receive.
        //kCLLocationAccuracyBest en fazla pil yiyen ama en doğru sonuç
        locationManager.requestWhenInUseAuthorization()
        //App kullanılırken location alır
        locationManager.startUpdatingLocation()// harita güncelleme
        
        
        //pinlemeye geçiş
        let gestureRescognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))//uzunca basınca çıksın
        gestureRescognizer.minimumPressDuration = 3 //3 sn bas
        mapView.addGestureRecognizer(gestureRescognizer)// mapView'a eklemek
        
        
        //TextField placeholder rengi
        nameText.attributedPlaceholder = NSAttributedString(
                string: "Name:",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
        commentText.attributedPlaceholder = NSAttributedString(
                string: "Comment:",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
    }
    
    @objc func chooseLocation(gestureRecognizer: UILongPressGestureRecognizer){
        //gestureRecognizer.state == .began bu tarz funcları almak için func girdi olarak gestureLocation'ı alıyor
        
        //tıklanan yerin koordinatlarını almak
        if gestureRecognizer.state == .began{
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let touchCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()//pinleme işlemi
            annotation.coordinate = touchCoordinate
            annotation.title = nameText.text
            annotation.subtitle = commentText.text
            self.mapView.addAnnotation(annotation)
            
            
        }
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //güncellenen lokasyonları locations: [CLLocation] kodu ile dizi içerisinde verir
        //CLLocation objesi enlem(latitude) boylam(longitude) veren bir obje.
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)//ne kadar küçük olursa o kadar zoomluyor
        let region = MKCoordinateRegion(center: location, span: span)//haritada nereyi ortalayayım ne kadar zoomla(span)
        mapView.setRegion(region, animated: true)//
        
        
    }
    
    

    

    

}
