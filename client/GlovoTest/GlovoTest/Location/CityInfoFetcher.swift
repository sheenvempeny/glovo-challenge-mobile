//
//  CityInfoFetcher.swift
//  GlovoTest
//
//  Created by sheen vempeny on 6/30/18.
//  Copyright © 2018 sheen vempeny. All rights reserved.
//

import Foundation

struct CityInfo: Codable {
    
    let working_area: [String]
    let time_zone: String
    let enabled: Bool
    let country_code: String
    let currency:String
    let name:String
    let code:String
    let busy:Bool
    let language_code:String
}

class CityInfoFetcher:Fetcher {

    var cityCode:String = ""
    
    override func makeRequest() {
        guard let url = URL(string: apiUrl + self.cityCode) else {
            return
        }
        self.urlRequest = URLRequest(url: url)
    }
    
    func fetch(result:@escaping (_ cityInfo:CityInfo?) -> Void) {
        
        self.fetchData(result: { (data:Data?) in
            
            guard let responseData = data else {
                result(nil)
                return
            }
            
            guard let cityInfo = try? JSONDecoder().decode(CityInfo.self, from: responseData) else {
                result(nil)
                return
            }
            
            result(cityInfo)
        })
    }
    
}


