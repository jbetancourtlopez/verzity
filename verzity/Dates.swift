//
//  Dates.swift
//  verzity
//
//  Created by Jossue Betancourt on 03/07/18.
//  Copyright © 2018 Jossue Betancourt. All rights reserved.
//

import Foundation
import UIKit

func get_day_of_week(today: String) -> String {
    //let isoDate = "2018-07-15T10:44:00+0000"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    //dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    //let date = dateFormatter.date(from: "2018-07-15T10:44:00+0000")!
    
    let date = dateFormatter.date(from: today)
    
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .weekday], from: date!)
    
    let year =  components.year
    let month = components.month
    let day = components.weekday
    
    print(year)
    print(month)
    print(day)
    
    var array_days = ["", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]
    
    
    return array_days[day!]
}
