//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 최수훈 on 2022/11/27.
//

import UIKit

// 삭제 delegate
protocol DiaryDetailViewDelegate: AnyObject {
    func didSelecteDelete(indexPath: IndexPath)
}

class DiaryDetailViewController: UIViewController {

    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLable: UILabel!
    var starButton: UIBarButtonItem?

    weak var delegate: DiaryDetailViewDelegate?
    // MARK: - 일기장 리스트에서 전달받을 프로퍼티 선언
    var diary: Diary?
    var indexPath : IndexPath?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
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
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary
        self.configureView()
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.didSelecteDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func tapStarButton() {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
