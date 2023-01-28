//
//  BeerListCell.swift
//  Brewery
//
//  Created by 최수훈 on 2023/01/28.
//

import UIKit
import SnapKit
import Kingfisher

class BeerListCell : UITableViewCell {
    // imageView, label 2개, indicator
    
    let beerImageView = UIImageView()
    let nameLabel = UILabel()
    let tagLineLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [beerImageView, nameLabel, tagLineLabel].forEach {
            contentView.addSubview($0)
        }
        
        beerImageView.contentMode = .scaleAspectFit
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.numberOfLines = 2
        
        tagLineLabel.font = .systemFont(ofSize: 14, weight: .light)
        tagLineLabel.textColor = .systemBlue
        tagLineLabel.numberOfLines = 0
        
        beerImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.top.bottom.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(120)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(beerImageView.snp.trailing).offset(10)
            $0.bottom.equalTo(beerImageView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        tagLineLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
        }
    }
    
    func configure(with beer: Beer) {
        let imageURL = URL(string: beer.imageURL ?? "")
        // 킹피셔로 이미지뷰에 뿌린다
        beerImageView.kf.setImage(with: imageURL, placeholder: UIImage(imageLiteralResourceName: "beer_icon"))
        nameLabel.text = beer.name ?? "이름 없는 맥주"
        tagLineLabel.text = beer.tagline
        
        
        accessoryType = .disclosureIndicator
        selectionStyle = .none // 탭 해도 음영 발생 no
    }
}
