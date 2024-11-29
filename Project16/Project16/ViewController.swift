//
//  ViewController.swift
//  Project16
//
//  Created by Alperen Çerkez on 28.11.2024.
//

import MapKit
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let istanbul = Capital(title: "Istanbul", coordinate: CLLocationCoordinate2D(latitude: 41.015137, longitude: 28.979530), info: "The only city in the world built on two continents")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the city of light")
        
        mapView.addAnnotations([istanbul, oslo, paris])
        
        
        
    }


}

