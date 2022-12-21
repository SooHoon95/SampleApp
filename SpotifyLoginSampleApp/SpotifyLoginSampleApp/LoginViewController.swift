//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 최수훈 on 2022/12/20.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 세가지 동일하게 레이어 줄거니까 for each 문 사용
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation Bar 숨기기
        navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func googleLoginButtonTap(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            if let error = error {
                print("Error Google SignIn \(error.localizedDescription)")
                return
            }
            guard let authentication = signInResult?.user else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken as? String ?? "", accessToken: authentication.accessToken as? String ?? "")
            
            Auth.auth().signIn(with: credential) { _, _ in
                self.showMainViewController()
            }
            
        }
    }
    
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    @IBAction func appleLoginButtonTap(_ sender: UIButton) {
    }
    
}
