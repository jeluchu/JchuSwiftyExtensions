//
//  NumericExtensions.swift
//  
//
//  Created by Jéluchu on 4/5/23.
//

import Foundation

public extension Numeric {
    var formattedWithSeparator: String {
        Formatter.withSeparator.string(for: self) ?? ""
    }

    var formattedWithThousandDot: String {
        Formatter.withThousandDot.string(for: self) ?? ""
    }
}
