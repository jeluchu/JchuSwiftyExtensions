//
//  FormatterExtensions.swift
//  
//
//  Authors: Jeluchu
//  Creation: 4/5/23
//

import Foundation

public extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        return formatter
    }()
    
    static let withThousandDot: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "es-ES")
        formatter.groupingSeparator = "."
        formatter.groupingSize = 3
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
