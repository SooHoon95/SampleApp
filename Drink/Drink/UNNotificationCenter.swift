//
//  UNNotificationCenter.swift
//  Drink
//
//  Created by 최수훈 on 2023/01/06.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
        // alert 객체 받아서 노티를 만들고 최종적으로 노티피케이션 센터에 추가하는 함수
    func addNotificationRequest(by alert: Alert) {
        let content = UNMutableNotificationContent()
        content.title = "물 마실 시간이에요💦"
        content.body = " 세계보건기구(WHO)가 권장하는 하루 물 섭취량은 1.5~2리터 입니다."
        content.sound = .default
        content.badge = 1
        
        // Trigger 설정
        let component = Calendar.current.dateComponents([.hour,.minute], from: alert.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)// 날짜 상관없이 시간이랑 분만 필요하다 여기서는 // repeat 여부는 스위치 값에 따라 달라지게한다.
    }
}
