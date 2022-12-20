//
//  CityCovidOverview.swift
//  COVID19
//
//  Created by 최수훈 on 2022/12/20.
//

import Foundation

struct CityCovidOverview: Codable {
    let korea: CovideOverview
    let seoul: CovideOverview
    let busan: CovideOverview
    let daegu: CovideOverview
    let incheon: CovideOverview
    let gwangju: CovideOverview
    let daejeon: CovideOverview
    let ulsan: CovideOverview
    let sejong: CovideOverview
    let gyeonggi: CovideOverview
    let gangwon: CovideOverview
    let chungbuk : CovideOverview
    let jeonbuk: CovideOverview
    let jeonnam: CovideOverview
    let gyeongbuk: CovideOverview
    let gyeongnam: CovideOverview
    let jeju: CovideOverview
}

struct CovideOverview: Codable {
    let countryName: String
    let newCase: String
    let totalCase: String
    let recovered: String
    let death: String
    let percentage: String
    let newCcase: String
    let newFcase: String
}
