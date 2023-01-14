//
//  ContentCollectionViewHeader.swift
//  NetflixStyleSampleApp
//
//  Created by 최수훈 on 2023/01/14.
//

import UIKit

// 섹션의 헤더
class ContentCollectionViewHeader: UICollectionReusableView { // 반드시 UICollectionReusableView 타입으로 지정해야 헤더 또는 풋터가 될 수 있다.
    
    let sectionNameLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sectionNameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        sectionNameLabel.textColor = .white
        sectionNameLabel.sizeToFit() // Call this method when you want to resize the current view so that it uses the most appropriate amount of space.
        
        addSubview(sectionNameLabel)
        
        sectionNameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.leading.equalToSuperview().offset(10)
        }
    }
    
    
}
