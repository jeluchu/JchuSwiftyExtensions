//
//  DateExtensions.swift
//  
//
//  Created by EstrHuP on 4/5/23.
//

import Foundation

extension DateFormatter {

    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
        self.locale = Locale.autoupdatingCurrent
        self.timeZone = TimeZone.autoupdatingCurrent
    }
}

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
}
