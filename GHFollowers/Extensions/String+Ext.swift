//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 04/04/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import Foundation


// EXTENSION TO GET A DATE STRING FROM SERVER AND CONVERT IT TO A DIFERNET TYPE OF DATE FORMAT
// the first part converts the string taken from the server to a Date format

extension String {
    
    
    // this function returns a Date? which is optioanl
    func convertToDate() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        
        return dateFormatter.date(from: self)
    }
    
    
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else {return "N/A"}
        return date.convertToMonthYearFormat()
    }
}
