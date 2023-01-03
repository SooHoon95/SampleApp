//
//  CardDetailViewController.swift
//  CreditCardList
//
//  Created by 최수훈 on 2023/01/03.
//

import UIKit
import Lottie

class CardDetailViewController : UIViewController {
    var promotionDetail: PromotionDetail?
    
    @IBOutlet weak var lottieView: LottieAnimationView! // money.json 에 있는 파일을 lottie가 해석해서 움짤을 생성한다.
    
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var benefitConditionLabel: UILabel!
    @IBOutlet weak var benefitDetailLabel: UILabel!
    @IBOutlet weak var benefitDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let animationView = LottieAnimationView(name: "money")
        lottieView.contentMode = .scaleAspectFit
        lottieView.addSubview(animationView)
        animationView.frame = lottieView.bounds
        animationView.loopMode = .loop
        animationView.play()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let detail = promotionDetail else { return }
        
        titleLable.text = """
        \(detail.companyName)카드 쓰면
        \(detail.amount)만원 돌려드려요
        """
        periodLabel.text = detail.period
        conditionLabel.text = detail.benefitCondition
        benefitConditionLabel.text = detail.benefitCondition
        benefitDetailLabel.text = detail.benefitDetail
        benefitDateLabel.text = detail.benefitDate
    }
}
