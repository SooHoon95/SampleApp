//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by 최수훈 on 2023/01/02.
//

import UIKit
import Kingfisher // 이미지 url 만 가지고 이미지를 불러오기
import FirebaseDatabase

class CardListViewController: UITableViewController {
    var ref: DatabaseReference!     // Firebase Database
    var creditCardList: [CreditCard] = [] // 처음에는 아무것도 전달 받지 못하니까 빈배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
        ref = Database.database().reference() // 파베 데이터 베이스에 넣어둔 데이터들을 가져올 수 있다.
        
        ref.observe(.value) { snapshot in                                               // ref를 옵저브하면서 value 값을 바라본다.
            guard let value = snapshot.value as? [String: [String: Any]] else { return }
            
            // json 디코딩 : 트라이문으로 가져온다.
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value) // 스냅샷을 가져온 value 가 오브젝트가 된다
                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
                let cardList = Array(cardData.values)                            // 딕셔너리 값일거니까 벨류만 가지고 온다
                self.creditCardList = cardList.sorted { $0.rank < $1.rank }      // 순위 정렬
                
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print("Error JSON parsing \(error.localizedDescription)")
            }
            
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 데이터 전달
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
    }
    
    // cell 높이 지정
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 특정 셀 선택했을 때 액션 -> 상세화면으로 이동
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else { return }
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)

        // 수정 Option 1
        let cardID = creditCardList[indexPath.row].id
//        ref.child("Item\(cardID)/isSelected").setValue(true)
        
        // 수정 Option 2 쿼리에서 특정값으로 검색
        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [ weak self ] snapshot in
            guard let self = self ,
                  let value = snapshot.value as? [String: [String: Any]],
                  let key = value.keys.first else { return }
            
            self.ref.child("\(key)/isSelected").setValue(true)
        }
    }
    
    // 특정 데이터삭제
    // 특정 신용카드 리스트에서 삭제하면 실제 데이터베ㅣ스에서 지우기
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // 삭제 Option 1
            let cardID = creditCardList[indexPath.row].id
            ref.child("Item\(cardID)").removeValue() // 해당경로에 있는 모든 데이터 삭제
            
            // Option 2  경로를 모를때 -> 검색 후 삭제
            ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [ weak self ] snapshot in
                guard let self = self,
                        let value = snapshot.value as? [String: [String: Any]],
                        let key = value.keys.first else { return }
                
                self.ref.child(key).removeValue()
            }
        }
    }
}
