//
//  ViewController.swift
//  Notice
//
//  Created by 최수훈 on 2023/01/04.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseAnalytics

class ViewController: UIViewController {

    var remoteConfig: RemoteConfig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteConfig = RemoteConfig.remoteConfig()
        
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0    // 테스트를 위한 새로운 값 패치를 최소화해서 최대한 자주 원격데이터를 가져올 수 있게 한다
        
        remoteConfig?.configSettings = setting
        
        // RemoteConfigDefaults 파일 연결
        remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNotice()
    }
}

// RemoteConfig
extension ViewController {
    func getNotice() {
        guard let remoteConfig = remoteConfig else { return }
        
        remoteConfig.fetch() { [weak self] status, _ in
            if status == .success {
                remoteConfig.activate()
            } else {
                print("Error : Config not fetched")
            }
            
            guard let self = self else { return }
            
            if !self.isNoticeHidden(remoteConfig) {
                let noticeVC = NoticeViewController(nibName: "NoticeViewController", bundle: nil)
                
                noticeVC.modalPresentationStyle = .custom
                noticeVC.modalTransitionStyle = .crossDissolve
                
                let title = (remoteConfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let detail = (remoteConfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let date =  (remoteConfig["date"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                
                noticeVC.noticeContents = (title: title, detail:detail, date: date)
                self.present(noticeVC, animated: true)
            } else {
                self.showEventAlert()
            }
        }
    }
    
    func isNoticeHidden(_ remoteConfig: RemoteConfig) -> Bool {
        return remoteConfig["isHidden"].boolValue
    }
}

// A/B Testing
extension ViewController {
    func showEventAlert() {
        
        guard let remoteConfig = remoteConfig else { return }
     
        remoteConfig.fetch() { [weak self] status, _ in
            if status == .success {
                remoteConfig.activate()
            } else {
                print("Config not fetched")
            }
            let message = remoteConfig["message"].stringValue ?? ""
            
            let confirmAction = UIAlertAction(title: "확인하기", style: .default) { _ in
                //Google Analytics에서 데이터를 확인할 수 있도록 보낸다
                Analytics.logEvent("promotion_alert", parameters: nil)
            }
            
            let cancleAction = UIAlertAction(title: "취소", style: .cancel)
            let alertController = UIAlertController(title: "깜짝이벤트", message: message, preferredStyle: .alert)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancleAction)
             
            self?.present(alertController,animated: true, completion: nil)
            
        }
        
    }
}

