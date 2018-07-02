//
//  MapViewController.swift
//  GlovoTest
//
//  Created by sheen vempeny on 6/30/18.
//  Copyright © 2018 sheen vempeny. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    weak var locManager:LocationManager!
    @IBOutlet weak var infoTableView:UITableView!
    private var overlay:GMSGroundOverlay!
    
    var city:City!{
        didSet{
            self.fetchCityInfo()
        }
    }
    private var cityInfo:CityInfo?{
        didSet{
            guard self.infoTableView != nil else{
                return
            }
             DispatchQueue.main.async(){
            
                self.infoTableView.reloadData()
            }
        }
    }
    
    private var markers:[GMSMarker]!
    private var mapView:GMSMapView!
    
    private var minZoom:Float = 7
    private var defaultZoom:Float = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMap()
         self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.infoTableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMap() {
        self.markers = []
        // Create a GMSCameraPosition that tells the map to display the
        let coordinate:CLLocationCoordinate2D = self.city.bounds.southWest
        
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: defaultZoom)
        self.mapView = GMSMapView.map(withFrame: CGRect(x: 0.0, y: 20.0, width: self.view.frame.size.width, height:self.view.frame.size.height - 160), camera: camera)
        mapView.delegate = self
        self.view.addSubview(mapView)
        self.addCities()
        self.centerLoc(coordinate: coordinate)
    }
    
    private func addMarker( aCity:inout City) -> GMSMarker{
        
        let coordinate:CLLocationCoordinate2D = aCity.bounds.southWest
        let aMarker = GMSMarker()
        aMarker.position = coordinate
        aMarker.title = aCity.name
        aMarker.snippet = aCity.code
        aMarker.map = mapView
        
        return aMarker
    }
    
    private func addCities(){
        for var aCity in self.locManager.cities! {
            let aMarker = self.addMarker(aCity: &aCity)
            self.markers.append(aMarker)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController:GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let zoom = mapView.camera.zoom
        
        for aMarker in self.markers{
            
            if zoom < minZoom {
                aMarker.icon = UIImage(named: "balloon")
            }
            else{
                aMarker.icon = nil
            }
        }
        
    }
    
    private func updateMapForMarker(marker:GMSMarker){
        let coordinate:CLLocationCoordinate2D = marker.position
        self.centerLoc(coordinate: coordinate)
        if let aCity = self.locManager.city(coordinate: coordinate) {
            self.city = aCity
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.updateMapForMarker(marker: marker)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        self.updateMapForMarker(marker: marker)
    }
    
    private func centerLoc(coordinate:CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: defaultZoom)
        self.mapView.camera = camera;
        self.updateOverlay()
    }
    
    private func updateOverlay(){
        self.overlay = GMSGroundOverlay(bounds: self.city.bounds, icon: UIImage(named: "green"))
        self.overlay.opacity = 0.5
        self.overlay.map = self.mapView
    }
    
 
    private func fetchCityInfo(){
        self.locManager.getCityInfo(cityCode: self.city.code) { (cInfo:CityInfo?) in
            if let ciInfo = cInfo {
                self.cityInfo = ciInfo
            }
        }
    }
    
}


extension MapViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if let  cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") {
            cell.textLabel?.textColor = UIColor.white
        
        var text:String = ""
        
        switch indexPath.row {
            
            case 0:
               let name = self.cityInfo?.name ?? ""
               text = "Name : " + name
            break
            case 1:
                let time_zone = self.cityInfo?.time_zone ?? ""
                text = "Time Zone : " + time_zone
            break
            case 2:
                let currency = self.cityInfo?.currency ?? ""
              text = "Currency : " + currency
            break
            
        default:
            break
        }
        
        cell.textLabel?.text = text
        return cell
    }
        
        return UITableViewCell()
    }
    
   
    
   
}

