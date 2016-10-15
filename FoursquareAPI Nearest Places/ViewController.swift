//
//  ViewController.swift
//  FoursquareAPI Nearest Places
//
//  Created by souq on 10/15/16.
//  Copyright © 2016 Odat. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {

    var locationManager:CLLocationManager?
    
    let distanceCovered:Double = 1000
    var restaurantsList = [Restaurent]()
    
    // Server request variable
    let clientID        = "JVX0WZ1PIYQJICIMZUJQGIA5L2JTCUEVIDCETZVZYYRMNUJD"
    let clientSecret    = "SNMRVYAOMS421JEMERMRIKBKRC0MMZWGF1CDF3AN1JCDPGIV"
    var lattidue        = ""
    var longitude       = ""
    var searchQuery     = ""
    
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
            lattidue = String(newLocation.coordinate.latitude)
            longitude = String(newLocation.coordinate.longitude)
            getData()
            let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, distanceCovered, distanceCovered)
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Adding pin to map view with params 
    // Name of pin, Lat and Lng of location
    func addPin(name: String, lat: Double, lng:Double){
        let annotation = MKPointAnnotation()
            annotation.coordinate.latitude = lat
            annotation.coordinate.longitude = lng
            annotation.title = name
            mapView.addAnnotation(annotation)
    }
    
    // Search query for specific places type
    // Get new data from server based on search query
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if searchBar.text != nil {
            searchQuery = searchBar.text!
            getData()
            self.view.endEditing(true)
        }
    }
    
    // Alamofire request to get data from server and parse it via Swifty Json
    func getData(){

        // Server request with params
        let server = "https://api.foursquare.com/v2/venues/search?client_id=\(clientID)&client_secret=\(clientSecret)&v=20130815&query=\(searchQuery)&ll=\(lattidue),\(longitude)"

        Alamofire.request(.GET, server).responseJSON { (response) -> Void in
            if((response.result.value) != nil) {
                let jsonResponseValue = JSON(response.result.value!)
                if let restaurentArray = jsonResponseValue["response"]["venues"].array {
                    // Removing all old elements in array
                    // Removing all old pins on map
                    self.restaurantsList.removeAll()
                    let allAnnotations = self.mapView.annotations
                    self.mapView.removeAnnotations(allAnnotations)
                    
                    // Adding new elements to array
                    // Adding new pins to map
                    for restDictinary in restaurentArray {
                        let restaurent = Restaurent(json: restDictinary)
                        self.restaurantsList.append(restaurent)
                        self.addPin(restaurent.name!,lat: restaurent.latitude!, lng: restaurent.longitude!)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}

