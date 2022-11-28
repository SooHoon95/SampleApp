//
//  ViewController.swift
//  Diary
//
//  Created by 최수훈 on 2022/11/27.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private var diaryList = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }

    private func configureCollectionView() {
        
        self.collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewCnotroller {
            writeDiaryViewController.delegate = self
        }
    }
    
    private func dateToString(date: Date) -> String{
        let formmater = DateFormatter()
        formmater.dateFormat = "yy년 MM월 dd일(EEEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        return formmater.string(from: date)
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() } // 다운케스팅 실패하면 빈 컬렉션뷰로 반환 , 성공하면 제목, 날짜 표시
        
        let diary = self.diaryList[indexPath.row]
        cell.titleLable.text = diary.title
        cell.dataLable.text = self.dateToString(date: diary.date)
        return cell
    }
    
    
    
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    // cell 의 사이즈를 결정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
        // 행에 두개씩 표시해줄거임.
        // 즉 아이폰 화면의 넓이를 2로 나누고 패딩값이 10 이기때문에 왼 + 오 하면 20 빼준다.
        
    }
}

extension ViewController : WriteDairyViewDelegate {
    func didSelectRegister(diaty: Diary) {
        self.diaryList.append(diaty) // -> 등록화면에서 작성한 다이어리를 가져와서 다이어리 리스트에 추가해준다. -> collectionView에 그려줘야한다. -> configureCollectionView()
        self.collectionView.reloadData()
    }
}

