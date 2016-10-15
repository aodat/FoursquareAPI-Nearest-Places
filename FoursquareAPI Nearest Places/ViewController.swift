//
//  ViewController.swift
//  FoursquareAPI Nearest Places
//
//  Created by souq on 10/15/16.
//  Copyright © 2016 Odat. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    var locationManager:CLLocationManager?
    let distanceCovered:Double = 1000
    var restaurantsList = [Restaurent]()

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchView: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsList.count
    }
    
    // Assign table view cell title to restaurant name
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        let restaurent = restaurantsList[indexPath.row]
        cell.textLabel?.text = restaurent.name
        return cell
    }
    
    // Get current location for user
    override func viewDidAppear(animated: Bool)
    {
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager!.requestAlwaysAuthorization()
            locationManager!.distanceFilter = 50
            locationManager!.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        }
    }
    
    // Creates a rectangular region of ( Distance coverd ) in meter
    // Pass new location lattitude and longitude to variable
    // Call getData to get restaurent for new location as per long & lat
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        if let mapView = self.mapView {
            API.lattidue = String(newLocation.coordinate.latitude)
            API.longitude = String(newLocation.coordinate.longitude)
            getData()
            let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distanceCovered, distanceCovered)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Adding pin to map view with params 
    // Name of pin, Lat and Lng of location
    func addPin(restaurentList: [Restaurent]){
        // Removing old pins on map
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        // Ading pins to map for each location
        for restaurant in restaurantsList {
            let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = restaurant.latitude!
            annotation.coordinate.longitude = restaurant.longitude!
            annotation.title = restaurant.name
            mapView.addAnnotation(annotation)
        }
    }
    
    // Search query for specific places type
    // Get new data from server based on search query
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text != nil {
            API.searchQuery = searchBar.text!
            getData()
            self.view.endEditing(true)
        }
    }
    
    // Get data method to collect data from server
    func getData(){
        API.getData { (success, response) in
            if success {
                self.restaurantsList = response
                self.addPin(response)
                self.tableView.reloadData()
            } else {
                // alert no data found
            }
        }
    }
}

