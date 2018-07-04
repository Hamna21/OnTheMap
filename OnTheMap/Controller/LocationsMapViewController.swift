//
//  LocationsMapViewController.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/24/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import UIKit
import MapKit

class LocationsMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var locationsMapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding Buttons to Navigtion Bar
        let addLocationButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refreshLocations))
        
        parent!.navigationItem.rightBarButtonItems = [addLocationButton, refreshButton]
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout))

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationsMapView.delegate = self
        refreshLocations()
    }
    
    // Attributes of each Pin on Map
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else{
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    //Action on Pin Tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView{
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!, let url = URL(string: toOpen) {
                app.open(url)
            }else{
                presentAlertController("URL not valid.")
            }
        }
    }
    
    //Populating Annotations Array
    func locationAnnotations(_ locations:[StudentInformation]){
        for location in locations{
            let lat = CLLocationDegrees(location.latitude!)
            let long = CLLocationDegrees(location.longitude!)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName!) \(location.lastName!)"
            annotation.subtitle = location.mediaURL
            
            annotations.append(annotation)
        }
    }
    
    //Add Location Button tapped
    @objc func addLocation(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ManagerAdditionNavigation") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    //Logout Button tapped
    @objc func logout(){
        UdacityClient.sharedInstance().deleteUserSession { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.dismiss(animated: true, completion: nil)
                }else{
                    self.presentAlertController("Error in Logout. Try Again.")
                }
            }
        }
        
    }
    //Refresh Button tapped
    @objc func refreshLocations(){
        ParseClient.sharedInstance().getStudentLocations { (success, error) in
            performUIUpdatesOnMain {
                if success!{
                    self.locationAnnotations(StudentLocations.locations)
                    self.locationsMapView.addAnnotations(self.annotations)
                }else{
                    self.presentAlertController(error)
                }
            }
        }
    }
    
    func presentAlertController(_ message: String? = nil){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
    

