//
//  WeatherInformation.swift
//  Weather
//
//  Created by 최수훈 on 2022/12/16.
//

import Foundation

// Codable : 자신을 변환하거나 외부표현으로 변환할 수 있는 타입 like JSON
// Decodable : 자신을 외부표현에서 디코딩할 수 있는 타입
// Codable : 자신을 외부표현에서 인코딩할 수 있는 타입
// 즉 Codable은 인코더블 + 디코더블이다 -> JSON 인코딩, 디코딩 모드 가능하다
// -> JSON 데이터를 WeatherInformation 타입으로 그 반대도 가능하다.
struct WeatherInformation : Codable {
    let weather : [Weather]
    let temp: Temp
    let name: String
    enum CodingKeys : String , CodingKey{
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable { // JSON 키와 프로퍼티 이름이 같아야한다. 만약다르게 하려면 CodingKeys 를 사용해서 커스텀할 수 있다.
    let id : Int
    let main : String
    let description : String
    let icon: String
}

struct Temp : Codable { // json과 다른 이름의 프로퍼티 네임 커스텀
    let temp : Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}


