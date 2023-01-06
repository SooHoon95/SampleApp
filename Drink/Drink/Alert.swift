//
//  Alert.swift
//  Drink
//
//  Created by 최수훈 on 2023/01/05.
//

import Foundation


struct Alert: Codable {
    var id: String = UUID().uuidString
    let date: Date
    var isOn: Bool
    
    var time: String {
        let timeFormmater = DateFormatter()
        timeFormmater.dateFormat = "hh:mm"
        return timeFormmater.string(from: date)
    }
    
    var merdiem: String{
        let meridiemFormatter = DateFormatter()
        meridiemFormatter.dateFormat = "a"
        meridiemFormatter.locale = Locale(identifier: "ko")
        return meridiemFormatter.string(from: date)
    }
}
