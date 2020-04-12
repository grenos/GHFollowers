//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Vasileios Gkreen on 04/04/2020.
//  Copyright © 2020 Vasileios Gkreen. All rights reserved.
//

import Foundation


// MARK: THIS IS NOT USED ANYMORE SINCE WE CONVERTED - DECODED THE STRING WE RECIEVE FROM THE API INTO A DATE FORMAT IN THE NETWORK MANAGER


extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        
        return dateFormatter.string(from: self)
    }
    
}
