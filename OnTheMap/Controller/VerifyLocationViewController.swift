//
//  VerifyLocationViewController.swift
//  OnTheMap
//
//  Created by Paul Davies on 30/03/2021.
//

import UIKit
import MapKit

class VerifyLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation?
    var locationText: String?
    var linkText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finishButton.layer.cornerRadius = 5
        
        mapView.delegate = self
        
        configureSelectedLocationPinOnMap()
    }
    
    fileprivate func configureSelectedLocationPinOnMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        annotation.title = locationText!
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: annotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func finish(_ sender: Any) {
        UdacityAPI.postLocation(mediaURL: linkText!, mapString: locationText!, latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude) { (success, error) in
            if success {
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            } else {
                self.presentErrorAlert(title: "Error posting location", message: error?.localizedDescription)
            }
        }
    }
    
    fileprivate func presentErrorAlert(title: String, message: String?) {
        let alertVC = UIAlertController(title: title, message: message?.description ?? "", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertVC.modalPresentationStyle = .overFullScreen
        self.present(alertVC, animated: true, completion: nil)
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
}
