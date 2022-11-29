//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 최수훈 on 2022/11/27.
//

import UIKit

// 삭제 delegate

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLable: UILabel!
    var starButton: UIBarButtonItem?

    // MARK: - 일기장 리스트에서 전달받을 프로퍼티 선언
    var diary: Diary?
    var indexPath : IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(starDiaryNotification(_:)),
            name: NSNotification.Name("starDiary"),
            object: nil)
    }
    
    private func configureView() {
        guard let diary = self.diary else { return }
        self.titleLable.text = diary.title
        self.contentsTextView.text = diary.contents
        self.dateLable.text = self.dateToString(date: diary.date)
        self.starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.starButton?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.starButton
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let viewController = self.storyboard?.instantiateViewController(identifier: "WriteDiaryViewCnotroller") as? WriteDiaryViewCnotroller else { return }
        guard let  indexPath = self.indexPath else { return }
        guard let diary = self.diary else { return }
        viewController.diaryEditorMode = .edit(indexPath, diary)
        
        // notificationCenter observing
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil
        )
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        // 수정된 객체 받아서 뷰에 업데이트
        guard let diary = notification.object as? Diary else { return }
        
        self.diary = diary
        self.configureView()
    }

    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String: Any] else  { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let diary = self.diary else { return }
        if diary.uuidString == uuidString {
            self.diary?.isStar = isStar
            self.configureView()
        }
        
    }
    
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let uuidString = self.diary?.uuidString else { return }
        NotificationCenter.default.post(
            name: Notification.Name("deleteDiary"),
            object: uuidString,
            userInfo: nil
        )
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapStarButton() {
        guard let isStar = self.diary?.isStar else { return }
//        guard let uuidString = self.diary?.uuidString else { return }
        if isStar {
            self.starButton?.image = UIImage(systemName: "star")
        } else {
            self.starButton?.image = UIImage(systemName: "star.fill")
        }
        self.diary?.isStar = !isStar
        
        NotificationCenter.default.post(
            name: NSNotification.Name("starDiary"),
            object: [
                "diary": self.diary,
                "isStar" : self.diary?.isStar ?? false,
                "uuidString" : diary?.uuidString
                ],
            userInfo: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
