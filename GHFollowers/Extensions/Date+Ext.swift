//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 04/04/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import Foundation


extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
    
}
