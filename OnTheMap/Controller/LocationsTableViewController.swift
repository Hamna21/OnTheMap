//
//  LocationsTableViewController.swift
//  OnTheMap
//
//  Created by Hamna Usmani on 6/23/18.
//  Copyright © 2018 Hamna Usmani. All rights reserved.
//

import SafariServices
import UIKit

class LocationsTableViewController: UIViewController {

    @IBOutlet weak var locationsTableView: UITableView!
    var locations : [StudentLocation]! = [StudentLocation]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addLocationButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
        let refreshButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refreshLocations))
        
        parent!.navigationItem.rightBarButtonItems = [addLocationButton, refreshButton]
        parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshLocations()
    }
    
    @objc func addLocation(){
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ManagerAdditionNavigation") as! UINavigationController
        present(controller, animated: true, completion: nil)
    }
    
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
    
    @objc func refreshLocations(){
        ParseClient.sharedInstance().getStudentLocations { (locations, error) in
            if let locations = locations {
                self.locations = locations
                performUIUpdatesOnMain {
                    self.locationsTableView.reloadData()
                }
            }else{
                self.presentAlertController(error)
            }
        }
    }
    
    func presentAlertController(_ message: String? = nil){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}

extension LocationsTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell") as UITableViewCell?
        let location = locations[indexPath.row]
        
        cell?.textLabel?.text = "\(location.firstName ?? "Empty") \(location.lastName ?? "Empty")"
        cell?.detailTextLabel?.text = location.mediaURL
        
        return cell!
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = locations[indexPath.row]
        if let urlString = location.mediaURL {
            let url = URL(string: urlString)
            //let config = SFSafariViewController.Configuration()
            //config.entersReaderIfAvailable = true
            
            let controller = SFSafariViewController(url: url!)
            present(controller, animated: true, completion: nil)
            
        }
    }
}
