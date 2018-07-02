//
//  CountryFetcher.swift
//  GlovoTest
//
//  Created by sheen vempeny on 6/29/18.
//  Copyright © 2018 sheen vempeny. All rights reserved.
//

import Foundation

struct Country: Decodable {
    
    let code: String
    let name: String
    var cities:[City]?
}

class CountryFetcher:Fetcher {

    func fetch(result:@escaping (_ countries:[Country]?) -> Void) {
        
        self.fetchData(result: { (data:Data?) in
            
            guard let responseData = data else {
                result(nil)
                return
            }
            
            guard let countries = try? JSONDecoder().decode([Country].self, from: responseData) else {
                result(nil)
                return
            }
            
            result(countries)
        })
    }
    
}
