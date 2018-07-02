//
//  LocationManager.swift
//  GlovoTest
//
//  Created by sheen vempeny on 6/28/18.
//  Copyright © 2018 sheen vempeny. All rights reserved.
//

import UIKit
import GoogleMaps

enum APICalls:String{
    
    case cityList = "http://localhost:3000/api/cities/"
    case countryList = "http://localhost:3000/api/countries/"
}

protocol LocationManDelegate:NSObjectProtocol {
    
    func currentLocFetched(location:CLLocation?)
}

class LocationManager:NSObject,CLLocationManagerDelegate {
    
    private var countryFetcher:CountryFetcher!
    private var cityFetcher:CityFetcher!
    private var cityInfoFetcher:CityInfoFetcher!
    let distance:CLLocationDistance = 1000
    private let locManager:CLLocationManager  = CLLocationManager()
    private weak var delegate:LocationManDelegate!
    
    convenience init(delegate:LocationManDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    var cities:[City]?
    var countries:[Country]?
    
    override init() {
        super.init()
        self.setupLocation()
        
        self.cityFetcher = CityFetcher(apiUrl: APICalls.cityList.rawValue)
        self.cityFetcher.fetch { (cities:[City]?) in
            self.cities = cities
            self.fillAndcheckLocation()
        }
        self.countryFetcher = CountryFetcher(apiUrl: APICalls.countryList.rawValue)
        self.countryFetcher.fetch { (conutries:[Country]?) in
            self.countries = conutries
             self.fillAndcheckLocation()
        }
        self.cityInfoFetcher = CityInfoFetcher(apiUrl: APICalls.cityList.rawValue)
    }
    
    func getCityInfo(cityCode:String,result:@escaping (_ cityInfo:CityInfo?) -> Void){
        self.cityInfoFetcher.cityCode = cityCode
        self.cityInfoFetcher.fetch { (cityInfo:CityInfo?) in
            result(cityInfo)
        }
    }
    
    private func fillCitiesForCountries(){
        
        var cntrs:[Country] = []
        for var cntry in self.countries!{
            let cities = self.cities?.filter({ $0.country_code ==  cntry.code})
            cntry.cities = cities
            cntrs.append(cntry)
        }
        
        self.countries = cntrs
    }
    
    private func fillAndcheckLocation(){
        guard self.cities != nil && self.countries != nil else {
            return
        }
        self.fillCitiesForCountries()
        DispatchQueue.main.async(){
            self.delegate.currentLocFetched(location: self.locManager.location)
        }
    }
    
    private func setupLocation(){
        self.locManager.requestWhenInUseAuthorization()
        self.locManager.requestAlwaysAuthorization()
        self.locManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locManager.startUpdatingLocation()
        self.locManager.distanceFilter = distance
    }
    
     func city(coordinate:CLLocationCoordinate2D) -> City?{
        
         for var aCity in self.cities!{
        
            if aCity.bounds.contains(coordinate) == true{
                    return aCity
            }
        }
     
        return nil
    }
    
}
