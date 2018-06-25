//
//  LocationAdditionMapViewController.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/25/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import UIKit
import MapKit

class LocationAdditionMapViewController: UIViewController, MKMapViewDelegate {
    var latitude: Double! = nil
    var longitude: Double! = nil
    var location: CLLocation!
    
    @IBOutlet weak var newLocationMapView: MKMapView!
    @IBOutlet weak var finishBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Location"
        newLocationMapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addAnnotationToMap()
        centerMapOnLocation(location: location)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil{
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
        }else{
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    //Adding pin of user entered location to map
    func addAnnotationToMap(){
        latitude = CLLocationDegrees(NewStudentLocation.Constants.Latitude)
        longitude = CLLocationDegrees(NewStudentLocation.Constants.Longitude)
        let coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        location = CLLocation(latitude: latitude, longitude: longitude)

        let annotataion = MKPointAnnotation()
        annotataion.coordinate = coordinate
        annotataion.title = NewStudentLocation.Constants.Location
      
        newLocationMapView.addAnnotation(annotataion)
        newLocationMapView.selectAnnotation(annotataion, animated: true)
    }
    
    // Map Center on Location according to user entered pin
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        newLocationMapView.setRegion(coordinateRegion, animated: true)
    }
    
    //Push location to server
    @IBAction func finishBtnTapped(_ sender: Any) {
        ParseClient.sharedInstance().addNewStudentLocation { (success, errorString) in
            performUIUpdatesOnMain {
                if success {
                    self.presentMainController()
                }else{
                    self.presentAlertController(errorString)
                }
            }
        }
    }
    
    func presentMainController(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
    func presentAlertController(_ message: String? = nil){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (alert: UIAlertAction!) in
           self.presentMainController()
        }))
        present(alertController, animated: true, completion: nil)
    }
}
