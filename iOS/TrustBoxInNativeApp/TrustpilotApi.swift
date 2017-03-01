//
//  TrustpilotApi.swift
//  TrustBoxInNativeApp
//
//  Copyright © 2017 Trustpilot A/S. All rights reserved.
//

import Foundation


class TrustpilotApi {
    private func getConfigurationString(key: String) -> String? {
        let path = Bundle.main.path(forResource: "configuration", ofType: "plist")
        let config = NSDictionary.init(contentsOfFile: path!)
        return config?.object(forKey: key) as? String
    }
    
    func getBusinessUnit(callback: @escaping (Any) -> Void ) {
        let businessUnitId = self.getConfigurationString(key: "businessUnitId")
        let url = "https://api.trustpilot.com/v1/business-units/\(businessUnitId!)"
        self.get(url: url, callback: callback)
    }

    func getReviews(callback: @escaping (Any) -> Void ) {
        let businessUnitId = self.getConfigurationString(key: "businessUnitId")
        let url = "https://api.trustpilot.com/v1/business-units/\(businessUnitId!)/reviews"
        self.get(url: url, callback: callback)
    }
    
    private func get(url: String, callback: @escaping (Any) -> Void) {
        let apiKey = self.getConfigurationString(key: "apiKey")
        
        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.setValue(apiKey, forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: [])
                callback(jsonResult)
            }
            catch let error as NSError {
                print(error)
            }
        })
        
        task.resume()
    }
}
