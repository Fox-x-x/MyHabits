//
//  DateToString.swift
//  MyHabits
//
//  Created by Pavel Yurkov on 14.11.2020.
//

import UIKit

extension UIViewController {
    
    /// конвертирует дату в формате Date в строку
    func dateToString(_ date: Date, withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: date)
    }
}
