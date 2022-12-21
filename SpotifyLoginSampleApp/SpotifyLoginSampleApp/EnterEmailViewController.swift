//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 최수훈 on 2022/12/20.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessagelabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.layer.cornerRadius = 30
        
        
        // 처음에 비활성화
        nextButton.isEnabled = false
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // 커서 자동으로 위치하기
        emailTextField.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // NavigationBar 보이기
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        //Firebase 이메일/비밀번호 인증
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // 인증플랫폼에 전달
        // 신규사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17007 : // 이미 가입한 계정일 때
                    // 로그인 하기
                    self.loginUser(witnEmail: email, password: password)
                default:
                    self.errorMessagelabel.text = error.localizedDescription
                }
            } else {
                self.showMainViewController()
            }
        }
    }
    
    private func showMainViewController () {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        navigationController?.show(mainViewController, sender: nil)
    }
    
    private func loginUser(witnEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [ weak self ] _, error in
            guard let self = self else { return }
            if let error = error {
                self.errorMessagelabel.text = error.localizedDescription
            } else {
                self.showMainViewController()
            }
            
        }
    }
}

extension EnterEmailViewController: UITextFieldDelegate {
    // 리턴 버튼눌르면 키보드 내려가게
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let isEmailEmpty = emailTextField.text == ""
        let isPasswordEmpty = passwordTextField.text == ""
        nextButton.isEnabled = !isEmailEmpty && isPasswordEmpty
    }
}
