//
//  ViewController.swift
//  GlovoTest
//
//  Created by sheen vempeny on 6/28/18.
//  Copyright © 2018 sheen vempeny. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var lblLoading:UILabel!
    private var locationManager:LocationManager!
    private var selectedCity:City!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = LocationManager(delegate: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LocSelViewSegue" {
            
            if let destinationVC = segue.destination as? LocSelViewController {
                destinationVC.countries = self.locationManager.countries
            }
        }
        
        if segue.identifier == "MapViewSegue" {
            if let destinationVC = segue.destination as? MapViewController {
                destinationVC.locManager = self.locationManager
                destinationVC.city = self.selectedCity
            }
        }
    }
    
    func citySelected(city: City){
        self.selectedCity = city
        self.performSegue(withIdentifier: "MapViewSegue", sender: self)
    }
    
}
extension ViewController:LocationManDelegate{
    
    func currentLocFetched(location: CLLocation?) {
        self.lblLoading.isHidden = true
        guard let currentLoc = location,let aCity = self.locationManager.city(coordinate:currentLoc.coordinate ) else{
            self.performSegue(withIdentifier: "LocSelViewSegue", sender: self)
            return
        }
        
        self.citySelected(city: aCity)
    }
}

