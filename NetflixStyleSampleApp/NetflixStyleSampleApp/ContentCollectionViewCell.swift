//
//  ContentCollectionViewCell.swift
//  NetflixStyleSampleApp
//
//  Created by 최수훈 on 2023/01/14.
//

import UIKit
import SnapKit

class ContentCollectionViewCell: UICollectionViewCell{
    
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        super .layoutSubviews()
        
        contentView.backgroundColor = .white // self.backGroundCOlor 가 아니라
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
        
        imageView.contentMode = .scaleToFill
        
        contentView.addSubview(imageView) // imageView를 view에 추가
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
}
