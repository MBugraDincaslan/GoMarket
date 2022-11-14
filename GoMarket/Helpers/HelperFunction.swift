//
//  HelperFunction.swift
//  GoMarket
//
//  Created by obss on 14.11.2022.
//

import Foundation


func convertToCurrency(_ number: Double) -> String {
    
    let currencyFormatter = NumberFormatter()
    currencyFormatter.usesGroupingSeparator = true
    currencyFormatter.numberStyle = .currency
    currencyFormatter.locale = Locale.current
    
    let priceString = currencyFormatter.string(from: NSNumber(value: number))!
    
    return currencyFormatter.string(from: NSNumber(value: number))!
}
