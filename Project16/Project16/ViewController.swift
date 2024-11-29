//
//  ViewController.swift
//  Project16
//
//  Created by Alperen Çerkez on 28.11.2024.
//

import MapKit
import UIKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let istanbul = Capital(title: "Istanbul", coordinate: CLLocationCoordinate2D(latitude: 41.015137, longitude: 28.979530), info: "The only city in the world built on two continents")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the city of light")
        
        mapView.addAnnotations([istanbul, oslo, paris])
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Map Type", style: .plain, target: self, action: #selector(changeMapType))
    }
    
    @objc func changeMapType() {
        let ac = UIAlertController(title: "Choose Map Type", message: nil, preferredStyle: .actionSheet)
        
        // Add map type options
        ac.addAction(UIAlertAction(title: "Standard", style: .default) { [weak self] _ in
            self?.mapView.mapType = .standard
        })
        ac.addAction(UIAlertAction(title: "Satellite", style: .default) { [weak self] _ in
            self?.mapView.mapType = .satellite
        })
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default) { [weak self] _ in
            self?.mapView.mapType = .hybrid
        })
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default) { [weak self] _ in
            self?.mapView.mapType = .satelliteFlyover
        })
        ac.addAction(UIAlertAction(title: "Muted Standard", style: .default) { [weak self] _ in
            self?.mapView.mapType = .mutedStandard
        })
        
        // Add cancel option
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        // Present the alert controller
        present(ac, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = .systemBlue
            annotationView?.glyphText = "🏙️"
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title?.replacingOccurrences(of: " ", with: "_") ?? ""
        let urlString = "https://en.wikipedia.org/wiki/\(placeName)"
        let placeInfo = capital.info
        
        if let url = URL(string: urlString) {
            let webVC = WebViewController()
            webVC.cityURL = url
            navigationController?.pushViewController(webVC, animated: true)
            
            let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
    }
    
}
