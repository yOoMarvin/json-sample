//
//  weather.swift
//  json-sample
//
//  Created by Marvin Messenzehl on 21.05.17.
//  Copyright © 2017 Marvin Messenzehl. All rights reserved.
//

import Foundation

struct Weather {
    
    let summary: String
    let icon: String
    let temperature: Double
    
    enum SerilizationError: Error {
        case missing(String)
        case invalid (String, Any)
    }
    
    init(json: [String:Any]) throws {
        guard let summary = json["summary"] as? String else {throw SerilizationError.missing("summary is missing")}
        guard let icon = json["icon"] as? String else {throw SerilizationError.missing("icon is missing")}
        guard let temperature = json["temperatureMax"] as? Double else {throw SerilizationError.missing("temp is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
    }
    
    
    static let basePath = "https://api.darksky.net/forecast/2d5a31bf6ea8b43e8f91ea88264c3e32/"
    
    static func forecast(withLocation location:String, completion: @escaping ([Weather]) -> ()) {
        
        let url = basePath + location
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response:URLResponse?, error:Error?) in
            
            var forecastArray:[Weather] = []
            
            if let data = data {
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForecasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForecasts["data"] as? [[String:Any]]{
                                for dataPoint in dailyData {
                                    if let weatherObject = try? Weather(json: dataPoint) {
                                        forecastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    
}
