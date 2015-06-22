//
//  MainViewController.swift
//  wt_login
//
//  Created by Margge Guiza.
//  Copyright (c) 2015 Margge Guiza. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MainViewController: UIViewController, MKMapViewDelegate{

    @IBOutlet weak var mapView: MKMapView!

    var newUser: UserModel!
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        mapView.delegate = self        
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
         centerMapOnLocation(userLocation.location)
    }
    
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
            mapView.showsUserLocation = true
        }
    }
    
    @IBAction func viewUserProfile(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let editProfileViewController = storyBoard.instantiateViewControllerWithIdentifier("WTEditProfileViewController") as! WTEditProfileViewController
            editProfileViewController.userProfile = newUser
        self.presentViewController(editProfileViewController, animated:true, completion:nil)
    }
   
    func centerMapOnLocation(location: CLLocation) {
        var userLocation: MKUserLocation = mapView.userLocation
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func logout(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ViewController") as! UIViewController
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
}
