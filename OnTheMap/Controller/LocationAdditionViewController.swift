//
//  LocationAdditionViewController.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/24/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import UIKit
import CoreLocation

class LocationAdditionViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let geocoder = CLGeocoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        linkTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationTextField.text = ""
        linkTextField.text = ""
        activityIndicator.isHidden = true
    }

    //Clicl on Cancel Bat button
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Find Location Button tapped
    @IBAction func findLocationTapped(_ sender: Any) {
        userDidTapView(self)
        
        if(locationTextField.text!.isEmpty || linkTextField.text!.isEmpty){
            presentAlertController("Location or Link missing.")
        }else{
            setUIEnabled(false)
            NewStudentLocation.Constants.Location = locationTextField.text!
            NewStudentLocation.Constants.Link = linkTextField.text!
            
            geocoder.geocodeAddressString(NewStudentLocation.Constants.Location, completionHandler: {(placemarks, error) -> Void in
                self.setUIEnabled(true)
                self.processResponsesPlacemark(withPlacemarks: placemarks, error: error)
            })
            
        }
    }
    //Fiding coordinates from response
    func processResponsesPlacemark(withPlacemarks placemarks: [CLPlacemark]?, error: Error?){
        if error != nil {
            self.presentAlertController("Location is not valid/searhcable. Try Again.")
        }else{
            var location : CLLocation!
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            if let location = location {
                let cooridnate = location.coordinate
                NewStudentLocation.Constants.Latitude = cooridnate.latitude as Double
                NewStudentLocation.Constants.Longitude = cooridnate.longitude as Double
                presentLocationMapVC()
                
            }
            
        }
    }
    
}

extension LocationAdditionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func resignIfFirstResponder(_ textField: UITextField){
        if textField.isFirstResponder{
            textField.resignFirstResponder()
        }
    }
    //Handling Tap on VIEW
    @IBAction func userDidTapView(_ sender: AnyObject){
        resignIfFirstResponder(locationTextField)
        resignIfFirstResponder(linkTextField)
    }
}

private extension LocationAdditionViewController {
    
    func setUIEnabled(_ enabled: Bool){
        locationTextField.isEnabled = enabled
        linkTextField.isEnabled = enabled
        submitButton.isEnabled = enabled
        activityIndicator.isHidden = enabled
        
        if enabled {
            submitButton.alpha = 1.0
            activityIndicator.stopAnimating()
        }else {
            submitButton.alpha = 0.5
            activityIndicator.startAnimating()
        }
    }
    
    func presentAlertController(_ message: String? = nil){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func presentLocationMapVC(){
        let mapController = self.storyboard?.instantiateViewController(withIdentifier: "LocationAdditionMapViewController") as! LocationAdditionMapViewController
        navigationController?.pushViewController(mapController, animated: true)
    }
}
