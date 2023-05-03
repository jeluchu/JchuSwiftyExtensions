//
//  StringExtensions.swift
//  
//
//  Created by Jéluchu on 4/5/23.
//

import Foundation

public extension String {
    var empty: String {
        return ""
    }
    
    var isBackspace: Bool {
        let char = self.cString(using: String.Encoding.utf8)!
        return strcmp(char, "\\b") == -92
    }
    
    var isEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format: "SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    
    var nameInitials: String {
        return split(" ")
            .prefix(2)
            .map({ $0.prefix(1) })
            .joined()
            .uppercased()
    }
    
    var cardLastFourNumbers: String {
        return String(self.suffix(4))
    }
    
    var isNumericWithSeparator: Bool {
        guard !isEmpty else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", " "]
        return Set(self).isSubset(of: nums)
    }
    
    var isFiscalNumberValid: Bool {
        let numbers = compactMap(\.wholeNumberValue)
        guard numbers.count == 9, Set(numbers).count != 1 else { return false }
        
        let validationOne = ["1", "2", "3", "5", "6", "8"]
        let validationTwo = ["45", "70", "71", "72", "74", "75", "77", "79", "90", "91", "98", "99"]
        
        let index = self.index(startIndex, offsetBy: 2)
        if !validationOne.contains(String(numbers[0])), !validationTwo.contains(String(prefix(upTo: index))) {
            return false
        }
        
        let total = numbers.dropLast().enumerated().map { index, element in
            element * (9 - index)
        }.reduce(0, +)
        
        let moduleEleven = total % 11
        
        let checkDigit = moduleEleven < 2 ? 0 : 11 - moduleEleven
        
        return checkDigit == numbers[8]
    }
    
    var setThousandSpaceMask: String {
        let replacedSeparator = replacingOccurrences(of: " ", with: "")
        
        if let doubleVal = Double(replacedSeparator), replacedSeparator.count % 3 == 0 {
            let requiredString = doubleVal.formattedWithSeparator
            return requiredString
        } else {
            return self
        }
    }
    
    var setLongAliasMask: String {
        if self.count > 20 {
            return String(self.prefix(20)) + "..."
        } else {
            return self
        }
    }
    
    var setNumericAliasMask: String {
        var alias = self.trimmingCharacters(in: .whitespaces)
        if alias.allSatisfy({ $0.isNumber }) {
            let index = alias.index(alias.startIndex, offsetBy: 4)
            alias.insert(" ", at: index)
            return alias
        }
        return self.setLongAliasMask
    }
    
    var setPrivateNumberMask: String {
        return "••• ••• " + String(self.suffix(3))
    }
    
    // MARK: Do NIF accept value zero
    var setThousandSpaceStringMask: String {
        let replacedSeparator = replacingOccurrences(of: " ", with: "")
        let breakStrings = componentsToStrings(withMaxLength: 3, andNewString: replacedSeparator)
        let requiredString = breakStrings.joined(separator: " ")
        return requiredString
    }
    
    var setThousandDotMask: String {
        let replacedSeparator = replacingOccurrences(of: ",", with: ".")
        if let doubleVal = Double(replacedSeparator) {
            let requiredString = doubleVal.formattedWithThousandDot
            return requiredString
        } else {
            return self
        }
    }
    
    // MARK: To Currency Euro
    /// The mask of type #.###,00€
    var currencyEuroFormatting: String {
        let replacedSeparator = replacingOccurrences(of: ",", with: ".")
        if let doubleVal = Double(replacedSeparator) {
            let requiredString = doubleVal.formattedWithThousandDot
            return requiredString + "€"
        } else {
            return self
        }
    }
    
    /// The mask of type #### ###########
    var accountNumberMask: String {
        var stringWithMask = self
        stringWithMask.insert(" ", at: index(startIndex, offsetBy: 4))
        return stringWithMask
    }
    
    // MARK: Do IBAN accept value zero
    var setFourSpaceStringMask: String {
        let replacedSeparator = replacingOccurrences(of: " ", with: "")
        if replacedSeparator.count % 4 == 1 {
            let breakStrings = componentsToStrings(withMaxLength: 4, andNewString: replacedSeparator)
            let requiredString = breakStrings.joined(separator: " ")
            return requiredString
        } else {
            return self
        }
    }
    
    var getCurrenceSymbol: String? {
        let locale = NSLocale(localeIdentifier: self)
        if locale.displayName(forKey: .currencySymbol, value: self) == self {
            let newlocale = NSLocale(localeIdentifier: dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: self)
        }
        return locale.displayName(forKey: .currencySymbol, value: self)
    }
    
    func separating(every: Int, separator: String) -> String {
        let regex = #"(.{\#(every)})(?=.)"#
        return self.replacingOccurrences(of: regex, with: "$1\(separator)", options: [.regularExpression])
    }
    
    // MARK: Do Break in words
    func componentsToStrings(withMaxLength length: Int, andNewString newString: String) -> [String] {
        stride(from: 0, to: newString.count, by: length).map {
            let start = newString.index(newString.startIndex, offsetBy: $0)
            let end = newString.index(start, offsetBy: length, limitedBy: newString.endIndex) ?? newString.endIndex
            return String(newString[start ..< end])
        }
    }
    
    // MARK: Payment Reference mask
    var setThreeSpaceStringMask: String {
        let replacedSeparator = replacingOccurrences(of: " ", with: "")
        if replacedSeparator.count % 3 == 0 {
            let breakStrings = componentsToStrings(withMaxLength: 3, andNewString: replacedSeparator)
            let requiredString = breakStrings.joined(separator: " ")
            return requiredString
        } else {
            return self
        }
    }
    
    func removeWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func toDoubleBasedOnLocation() -> Double? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator =  ","
        formatter.groupingSeparator = "."
        let number = formatter.number(from: self)
        return number?.doubleValue
    }
    
    
    func indexDistance(of character: Character) -> Int? {
        guard let index = firstIndex(of: character) else {
            return nil
        }
        return distance(from: startIndex, to: index)
    }
    
    func substring(with nsrange: NSRange) -> String? {
        guard let range = Range(nsrange, in: self) else {
            return nil
        }
        return String(self[range])
    }
    
    func substring(_ beginIndex: Int, _ endIndex: Int) -> String? {
        return substring(with: NSRange(location: beginIndex, length: endIndex - beginIndex))
    }
    
    func substring(_ beginIndex: Int) -> String? {
        return substring(with: NSRange(location: beginIndex, length: self.count - beginIndex))
    }
    
    
    func substring(to: PartialRangeUpTo<Int>) -> String {
        return String(self[..<index(startIndex, offsetBy: to.upperBound)])
    }
    
    
    func replace(_ target: String, _ replacement: String) -> String {
        return self.replacingOccurrences(of: target, with: replacement)
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func splitByLength(_ length: Int) -> [String] {
        guard length > 0 else { return [self] }
        var result = [String]()
        var msg = self
        let numberOfIterations = Int(ceil( Double(msg.count) / Double(length) ))
        for _ in 0 ..< numberOfIterations where !msg.isEmpty {
            let splitIndex = min(msg.count, length)
            result.append(String(msg.prefix(splitIndex)))
            msg = String(msg.suffix(msg.count - splitIndex))
        }
        return result
    }
    
    func split(_ value: String) -> [String] {
        return self.components(separatedBy: value)
    }
    
    
    func toDate(dateFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        return dateFormatter.date(from: self)
    }
    
    var account34: String {
        return completeRightCharacter(size: 34, char: " ")
    }
    
    func completeRightCharacter(size: Int, char: String = "") -> String {
        var temp = ""
        for _ in (0..<size - self.count) {
            temp = temp + char
        }
        return self + temp
    }
    
    var bicSwift11: String {
        return completeRightCharacter(size: 11, char: "X")
    }
    
    var hexStringToString: String {
        var chars = [Character]()
        var final = ""
        
        for c in self {
            chars.append(c)
        }
        
        let numbers = stride(from: 0, to: chars.count, by: 2).map {
            strtoul(String(chars[$0 ..< $0+2]), nil, 16)
        }
        
        for (_, num) in numbers.enumerated() {
            if let unicode = UnicodeScalar(Int(num)) {
                final.append(Character(unicode))
            }
        }
        
        return final
    }
}
