//
//  DateExtensions.swift
//  
//
//  Authors: EstrHuP and Jeluchu
//  Creation: 4/5/23
//

import Foundation

public extension Date {
    
    //MARK: - Date Formatter
    
    struct Formatter {
        
        // Services formats
        static let serviceISOTimeZone = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let timeShort = "HH:mm"
    }
    
    //MARK: - Utils functions
    
    /// Get end of week
    var endOfWeek: Date? {
        let gregorian = Calendar(identifier: .gregorian)
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)
    }
    
    /// Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    /// Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    /// Date format to dd/MM/yyyy
    func dayMonthYear() -> String {
        let format = "dd/MM/yyyy"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    
    enum WeekDay: Int {
        case monday = 0
        case tuesday = 1
        case wednesday = 2
        case thurday = 3
        case friday = 4
        case saturday = 5
        case sunday = 6
    }
    
    /// Return (day, month, year, weekday, hour, minutes)
    func getComponents() -> (day: Int, month: Int, year: Int, weekday: Int, hour: Int, minutes: Int, dayOfYear: Int) {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        let weekDay: Int = {
            switch calendar.component(.weekday, from: self) {
            case 1: return WeekDay.sunday.rawValue
            case 2: return WeekDay.monday.rawValue
            case 3: return WeekDay.tuesday.rawValue
            case 4: return WeekDay.wednesday.rawValue
            case 5: return WeekDay.thurday.rawValue
            case 6: return WeekDay.friday.rawValue
            case 7: return WeekDay.saturday.rawValue
            default: return 0
            }
        }()
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: self) ?? 1
        return (day, month, year, weekDay, hour, minutes, dayOfYear)
    }
    
    /// Compare date to today
    func isSameDay(compareDate: Date) -> Bool {
        let dateComponents = self.getComponents()
        let compDateComponents = compareDate.getComponents()
        return dateComponents.day == compDateComponents.day &&
        dateComponents.month == compDateComponents.month &&
        dateComponents.year == compDateComponents.year
    }
    
    func formattedStringToDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        guard let commingDate = dateFormatter.date(from: date) else {
            return "there is no date"
        }
        return formattedEachDay(date: commingDate, dateFormatter: dateFormatter)
    }
    
    /// "EEEE dd MMMM yyyy"
    func formattedStringToFullDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    /// "dd MMMM yyyy"
    func formattedStringToHalfDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func stringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.date(from: date)
        return dateFormatter.date(from: date) ?? Date(timeIntervalSinceNow: 00-00-0000)
    }
    
    func stringToDateC(date: String) -> Date {
        var valueDate = date
        if date.count > 8 {
            valueDate = String(date.prefix(8))
        }
        valueDate.insert("-", at: valueDate.index(valueDate.startIndex, offsetBy: 6))
        valueDate.insert("-", at: valueDate.index(valueDate.startIndex, offsetBy: 4))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.date(from: valueDate)
        return dateFormatter.date(from: valueDate) ?? Date(timeIntervalSinceNow: 00-00-0000)
    }
    func formattedDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return formattedEachDay(date: date, dateFormatter: dateFormatter)
    }
    
    func formattedDayWeekMonthYear(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func formattedYearMonthAndDay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    /// E, dd MMMM yyyy, HH:mm
    /// Example: Seg, 24 maio 2021, 08:46
    func formattedWeekDayMonthYearDateTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, dd MMMM yyyy, HH:mm"
        var stringDate = dateFormatter.string(from: date)
        stringDate = stringDate.prefix(1).uppercased() + stringDate.dropFirst()
        stringDate = stringDate.replacingOccurrences(of: ".", with: "")
        return stringDate
    }
    
    func formattedEachDay(date: Date, dateFormatter: DateFormatter) -> String {
        let timeInterval = date.timeIntervalSinceNow
        let calendar = Calendar.current
        
        let localDate = Date(timeIntervalSinceNow: timeInterval)
        
        if calendar.isDateInYesterday(localDate) {
            dateFormatter.dateFormat = "dd MMM"
            return String(
                format: "%@ | %@",
                dateFormatter.string(from: date),
                NSLocalizedString("date_yesterday", comment: "")
            ).uppercased()
        }else if !calendar.isDate(Date(), equalTo: date, toGranularity: .year) {
            dateFormatter.dateFormat = "dd MMM yyyy | EEEE"
            dateFormatter.string(from: date)
            return dateFormatter.string(from: date).uppercased()
        } else {
            dateFormatter.dateFormat = "dd MMM | EEEE"
            dateFormatter.string(from: date)
            return dateFormatter.string(from: date).uppercased()
        }
    }
}


extension DateFormatter {
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
        self.locale = Locale.autoupdatingCurrent
        self.timeZone = TimeZone.autoupdatingCurrent
    }
}
