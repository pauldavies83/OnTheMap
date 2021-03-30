//
//  PinsMapViewController.swift
//  OnTheMap
//
//  Created by Paul Davies on 28/03/2021.
//

import UIKit
import MapKit

class PinsMapViewController: PinsViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        drawMapAnnotations()
        
        super.refreshDataCompleted = {
            self.drawMapAnnotations()
        }
    }
    
    @objc override func refresh() {
        super.refresh()
    }
    
    fileprivate func drawMapAnnotations() {
        mapView.removeAnnotations(mapView.annotations)

        let annotations = locations.map { (value: StudentInformation) -> MKAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: value.latitude, longitude: value.longitude)
            annotation.title = "\(value.firstName) \(value.lastName)"
            annotation.subtitle = value.mediaURL
            return annotation
        }
        
        mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "annotation"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let urlString = view.annotation?.subtitle ?? ""
        let urlToOpen = URL(string: urlString!)
        if urlToOpen != nil {
            UIApplication.shared.open(urlToOpen!, options: [:], completionHandler: nil)
        } else {
            return
        }
    }
}
