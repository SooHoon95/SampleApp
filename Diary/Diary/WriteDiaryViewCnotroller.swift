//
//  WriteDiaryViewCnotroller.swift
//  Diary
//
//  Created by 최수훈 on 2022/11/27.
//

import UIKit

enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

// 일기장에 리스트화면에 일기가 작성된 다이어리 객체 전달.
protocol WriteDairyViewDelegate : AnyObject {
    func didSelectRegister(diary: Diary)
    // 작성완료된 일기의 객체를 전달
}

class WriteDiaryViewCnotroller: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    // pIcker에서 선택한 data 변수
    private var diaryDate: Date?
    weak var delegate: WriteDairyViewDelegate?
    
    var diaryEditorMode: DiaryEditorMode = .new
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureContentsTextView()
        self.configurationDataPicker()
        self.configureInputField()
        self.configureEditorMode()
        self.confirmButton.isEnabled = false
        
    }
    
    private func configureEditorMode() {
        switch self.diaryEditorMode {
        case let .edit(_, diary) :
            self.titleTextField.text = diary.title
            self.contentsTextView.text = diary.contents
            self.dateTextField.text = self.dateToString(date: diary.date)
            self.diaryDate = diary.date
            self.confirmButton.title = "수정"
            
        default:
            break
        }
        
    }
    
    private func dateToString(date: Date) -> String{
        let formmater = DateFormatter()
        formmater.dateFormat = "yy년 MM월 dd일(EEEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        return formmater.string(from: date)
    }
    
    private func configurationDataPicker() {
        self.datePicker.datePickerMode = .date
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged // 언제 호출할건지
        )
        self.datePicker.locale = Locale(identifier: "ko-KR")
        self.dateTextField.inputView = self.datePicker
    }
    
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    private func configureInputField() {
        self.contentsTextView.delegate = self
        self.titleTextField.addTarget(self, action: #selector(titleTextFieldDidChange(_: )), for: .editingChanged)
        self.dateTextField.addTarget(self, action: #selector(dateTextFieldDidChange(_: )), for: .editingChanged)
    }
    
    
    @IBAction func tapConfirmButton(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text else  { return }
        guard let contents = self.contentsTextView.text else { return }
        guard let date = self.diaryDate else { return }
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        
        switch self.diaryEditorMode {
        case .new :
            self.delegate?.didSelectRegister(diary: diary)
            
        case let .edit(indexPath, _):
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary, // 노티피케이션샌터를 통해 전달할 객체
                userInfo: [
                    "indexPath.row" : indexPath.row
                ]
            )
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formmater = DateFormatter() // date -> 사람이 읽는 형태로 변환 , 날짜 문저열에서 -> date 타입으로 변환
        formmater.dateFormat = "yyyy년 MM월 dd일(EEEEE)" // (EEEEEE) 요일 한번만 표시
        formmater.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.dateTextField.text = formmater.string(from: datePicker.date)
        // dateTextField 는 키보드 값이 아닌 datePicker의 값이므로
        // dateTextFieldDidChange 메소드가 호출되지않는다.
        // datePicker로 날짜를 변경해도 editingChange 액션을 발생시켜서
        // 변화를 감지한다.
        self.dateTextField.sendActions(for: .editingChanged)
        
    }
    
    @objc private func titleTextFieldDidChange(_ textField: UITextField) {
        self.validateInputField() // 제목 입력될때마다 등록버튼 활성화 판단
    }
    
    @objc private func dateTextFieldDidChange(_ textField : UITextField) {
        self.validateInputField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 등록버튼 활성화 여부 판단 매소드
    private func validateInputField() {
        self.confirmButton.isEnabled = !(self.titleTextField.text?.isEmpty ?? true) && !(self.dateTextField.text?.isEmpty ?? true) && !self.contentsTextView.text.isEmpty
    }
}


extension WriteDiaryViewCnotroller : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // 내용이 입력될 때 마다 호출됨
        self.validateInputField()
    }
}
