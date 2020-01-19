//
//  Date.swift
//  Contact
//
//  Created by Andrew O'Brien on 11/17/19.
//  Copyright © 2019 Andrew O'Brien. All rights reserved.
//

import Foundation

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var twoDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var threeDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var fourDaysAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var twoHoursAgo: Date {
        return Calendar.current.date(byAdding: .hour, value: -2, to: noon)!
    }
    var fiveHoursAgo: Date {
        return Calendar.current.date(byAdding: .hour, value: -5, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var oneYearAgo: Date {
        return Calendar.current.date(byAdding: .month, value: -12, to: noon)!
    }
    var oneWeekAgo: Date {
        return Calendar.current.date(byAdding: .day, value: -7, to: noon)!
    }
    var oneMonthAgo: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: noon)!
    }
    var threeMonthsAgo: Date {
        return Calendar.current.date(byAdding: .month, value: -3, to: noon)!
    }
    var infiniteAgo: Date {
        return Calendar.current.date(byAdding: .year, value: 100, to: noon)!
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
}

extension Date {
    static func currentYear() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: Date())
    }
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
    
    static func getCurrentDate() -> Date {
        return Date()
    }
    
    static func age(_ birthdate: Date) -> Int {
        return Date.getCurrentDate().years(from: birthdate)
    }
    
    static func birthdate(_ birthday: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.date(from: birthday)
    }
    
    static func dateFromString(_ string: String, _ format: String)  -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
}

extension Date {
    static var months: [String] =
        ["January",
         "February",
         "March",
         "April",
         "May",
         "June",
         "July",
         "August",
         "September",
         "October",
         "November",
         "December"
    ]
    
    static var days: [String] = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31",]
    
    static var yearsTillNow: [String] {
        var years = [String]()
        
        let thisYear = Date.currentYear()
        
        for year in (1950...thisYear).reversed() {
            years.append("\(year)")
        }
        return years
    }
    
    static var legalAgeYears: [String] {
        var years = [String]()
        
        let imEighteen = Date.currentYear() - 18
        
        for year in (1950...imEighteen).reversed() {
            years.append("\(year)")
        }
        return years
    }
}


