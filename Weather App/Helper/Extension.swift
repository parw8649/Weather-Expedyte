//
//  Extension.swift
//  Weather App
//
//  Created by Chaitanya on 12/12/22.
//
import UIKit
import Foundation
extension UIView {
    
    
    var cornerRadius : CGFloat {
        
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    func setShadoView() {
        
        let layer = self.layer
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2
        layer.masksToBounds = false
    }
    
}

func createDateTime(timestamp: String, dateFormat : String) -> String {
    
    var strDate = "undefined"
    
    if let unixTime = Double(timestamp) {
        let date = Date(timeIntervalSince1970: unixTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let timezone = TimeZone.current.abbreviation() ?? "GTM"
        dateFormatter.timeZone = TimeZone(abbreviation: timezone)
        dateFormatter.locale = NSLocale.current
        strDate = dateFormatter.string(from: date)
    }
    
    return strDate
    
}




