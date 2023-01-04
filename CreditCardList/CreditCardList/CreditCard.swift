//
//  CreditCard.swift
//  CreditCardList
//
//  Created by 최수훈 on 2023/01/02.
//

import Foundation

// 이 객체를 읽기도(Json decoding), 쓰기(Json encoding)도 한다.

struct CreditCard: Codable {
    let id: Int
    let rank: Int
    let name: String
    let cardImageURL: String
    let promotionDetail: PromotionDetail
    let isSelected: Bool? // 사용자가 카드 선택했을때 값을 가지고 그전까지는 nil
}

struct PromotionDetail: Codable {
    let companyName: String
    let period: String
    let amount: Int
    let condition: String
    let benefitCondition: String
    let benefitDetail: String
    let benefitDate: String
}
