//
//  RoundButton.swift
//  Calculator
//
//  Created by 최수훈 on 2022/11/22.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {
    
    // @IBInspectable을 붙이면 스토리보드에서도 이 변경값을 수정할 수 있게 된다.
    @IBInspectable var isRound: Bool = false {
        didSet {
            if isRound {
                // 정사각형인 버튼들은 원이되고 정사각형이 아닌 버튼들은 엣지가 둥글게 된다.
                self.layer.cornerRadius = self.frame.height / 2
            }
        }
    }
}
