//
//  DiaryCell.swift
//  Diary
//
//  Created by 최수훈 on 2022/11/27.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var dataLable: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
        self.contentView.layer.borderWidth = 1.0
    }
}
