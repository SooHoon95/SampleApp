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
import AuthenticationServices
import CryptoKit // Hash 값 추가를 위한 kit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: GIDSignInButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    fileprivate var currentNonce: String?
    
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
            print("token: \(authentication.idToken!.tokenString)")
            
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken!.tokenString, accessToken: authentication.accessToken.tokenString)
            
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
        startSignInWithAppleFlow()
    }
    
}
 

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            /*
             Nonce 란?
             - 암호화 된 임의의 난수
             - 단한번만 사용할 수 있는 값
             - 주로 암호화 통신을 할 때 활용
             - 동일한 요청을 짧은 시간에 여러번 보내는 릴레이 공격방지
             - 정보탈취 없이 안전하게 인증정보 전달을 위한 안전장치
             
             */
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print ("Error Apple sign in: %@", error)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                ///Main 화면으로 보내기
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
                mainViewController.modalPresentationStyle = .fullScreen
                self.navigationController?.show(mainViewController, sender: nil)
            }
        }
    }
}


//Apple Sign in
extension LoginViewController {
    func startSignInWithAppleFlow() {   // 애플에 인증값을 생성할떄 request를 생성
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email] // request에 nonce 포함해서 릴레이 공격 방지 및 무결성생성 가능
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}

extension LoginViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
