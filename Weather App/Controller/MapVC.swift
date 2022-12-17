//
//  MapVC.swift
//  Weather App
//
//  Created by Chaitanya on 12/12/22.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var centerMapCoordinate:CLLocationCoordinate2D!
    
    var locc = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        // for long press to drop pin on map
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        longTapGesture.minimumPressDuration = 0.2
        mapView.addGestureRecognizer(longTapGesture)
        
    }
    
    // for long press to drop pin on map
    @objc func longTap(longGesture: UILongPressGestureRecognizer) {
        
        if longGesture.state == .ended {
            
            let touchPoint = longGesture.location(in: mapView)
            let wayCoords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: wayCoords.latitude, longitude: wayCoords.longitude)
          
            DispatchQueue.main.async { [self] in
                
                addAnnotation(location: location.coordinate)
                locc = location.coordinate
            }
        }
        
        print("Touch")
        
    }
    
    // for add annotation on map
    func addAnnotation(location: CLLocationCoordinate2D){
        
        removeAnnotation()
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        self.mapView.addAnnotation(annotation)
        self.mapView.reloadInputViews()
        
    }
    
    // for select Pin to get thier detail
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView){
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "MapDetailVC")as! MapDetailVC
        vc.loc = locc
        self.present(vc, animated: true, completion: nil)
        
    }
    
    // for remove annotation
    func removeAnnotation(){
        
        self.mapView.annotations.forEach {
            
            if !($0 is MKUserLocation) {
                self.mapView.removeAnnotation($0)
            }
        }
    }
    
    
    
    
}
