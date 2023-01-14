//
//  Content.swift
//  NetflixStyleSampleApp
//
//  Created by 최수훈 on 2023/01/14.
//

import UIKit

struct Content: Decodable { // 인코딩은 필요없다 왜냐하면 데이터베이스 쓰기 작업이 없고 읽기작업만 있기때문에
    
    let sectionType: SectionType
    let sectionname: String
    let contentItem: [Item]
    
    enum SectionType: String, Decodable {
        case basic
        case main
        case large
        case rank
    }
    
}

struct Item: Decodable {
    let description: String
    let imageName: String
    
    // image 네임을 String 에서 바로 UIImage로 변환 가능
    var image: UIImage {
        return UIImage(named: imageName) ?? UIImage()
    }
}
