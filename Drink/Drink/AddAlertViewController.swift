//
//  File.swift
//  Drink
//
//  Created by 최수훈 on 2023/01/05.
//

import UIKit


class AddAlertViewController: UIViewController {
    
//    설정한 시간값이 부모뷰에 전달한다. :여기서는 클로저를 통해서
    var pickedDate: ((_ date: Date) -> Void)?
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        pickedDate?(datePicker.date)
        self.dismiss(animated: true)
    }
}
