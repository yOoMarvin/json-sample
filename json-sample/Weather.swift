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
    
}
