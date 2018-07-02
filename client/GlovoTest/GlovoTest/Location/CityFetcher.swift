//
//  CityFetcher.swift
//  GlovoTest
//
//  Created by sheen vempeny on 6/29/18.
//  Copyright © 2018 sheen vempeny. All rights reserved.
//

import Foundation
import GoogleMaps

struct City: Codable {
    
    let working_area: [String]
    let code: String
    let name: String
    let country_code: String?
    
    lazy var bounds:GMSCoordinateBounds = self.area()
    
    private func area() -> GMSCoordinateBounds{
        
        let boundsPath:GMSMutablePath = GMSMutablePath()
        
        for wArea in self.working_area {
        
            if let path:GMSPath = GMSPath(fromEncodedPath: wArea) {
               
                let length = path.count()
                for i in 0 ..< length {
                    let coordinate = path.coordinate(at: i)
                    boundsPath.add(coordinate)
                }
            }
        }
        
        let  bounds:GMSCoordinateBounds = GMSCoordinateBounds(path: boundsPath)
        return bounds
    }
}


class Fetcher {
    
    var urlRequest:URLRequest?
    var apiUrl:String
    init(apiUrl:String) {
        // Set up the URL request
        self.apiUrl = apiUrl
    }
    
    func makeRequest() {
        guard let url = URL(string: apiUrl) else {
            return
        }
        self.urlRequest = URLRequest(url: url)
    }
    
    func fetchData(result:@escaping (_ data:Data?) -> Void){
        self.makeRequest()
        guard self.urlRequest != nil else{
            result(nil)
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: self.urlRequest!, completionHandler: { data, response, error in
            
            guard error == nil || data == nil else{
                result(nil)
                return
            }
            result(data)
            return
            
        })
        
        task.resume()
    }
}


class CityFetcher:Fetcher {
    
    func fetch(result:@escaping (_ cities:[City]?) -> Void) {
       
        self.fetchData(result: { (data:Data?) in
            
            guard let responseData = data else {
                result(nil)
                return
            }
            
            guard let cities = try? JSONDecoder().decode([City].self, from: responseData) else {
                result(nil)
                return
            }
            
            result(cities)
        })
    }
    
}
