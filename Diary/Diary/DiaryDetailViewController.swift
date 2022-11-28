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
    }
    
    private func dateToString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath = self.indexPath else { return }
        self.delegate?.didSelecteDelete(indexPath: indexPath)
        self.navigationController?.popViewController(animated: true)
    }
}
