//
//  ViewController.swift
//  pomodoro
//
//  Created by 최수훈 on 2022/12/05.
//

import UIKit
import AudioToolbox

enum TimerStatus {
    case start
    case pause
    case end
}

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // datePicker 초기 설정
    var duration = 60
    // 타이머의 상태값을 가짐
    var timerStatus : TimerStatus = .end
    var timer : DispatchSourceTimer?
    var currentSecounds = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureToggleButton()
    }
    
    func setTimerInfoViewVisible(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }
    
    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    
    func startItmer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main)
            self.timer?.schedule(deadline: .now() , repeating: 1) // deadline: 언제 실행을 시킬건지, repeating: 몇초마다 반복될건지 설정
            self.timer?.setEventHandler(handler:  { [weak self] in
                guard let self = self else { return }
                self.currentSecounds -= 1
                let hour = self.currentSecounds / 3600
                let minutes = (self.currentSecounds % 3600) / 60
                let seconds = (self.currentSecounds % 3600) % 60
                self.timerLabel.text = String(format: "%02d : %02d : %02d", hour,minutes,seconds)
                self.progressView.progress = Float(self.currentSecounds) / Float(self.duration)
                // timer가 동작할때마다 이 클로저가 실행된다.
                
                UIView.animate(withDuration: 0.5 , delay: 0, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                })
                UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
                    self.imageView.transform = CGAffineTransform(rotationAngle: .pi * 2)
                })
                
                if self.currentSecounds <= 0 {
                    self.stopTimer()
                    // https://fastcampus.co.kr/courses/205949/clips/  에서 오디오 서비스 아이디 값
                    AudioServicesPlaySystemSound(1005)
                }
            })
            // 타이머가 종료
            self.timer?.resume()
        }
    }
    
    
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.stopTimer()
            
        default:
            break
        }
    }
    
    func stopTimer() {
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        self.timerStatus =  .end
        self.cancelButton.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            self.timerLabel.alpha = 0
            self.progressView.alpha = 0
            self.datePicker.alpha = 1
            self.imageView.transform = .identity
        })
        self.toggleButton.isSelected = false
        self.timer?.cancel()// 타이머 종료
        self.timer = nil
        
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePicker.countDownDuration)
        switch self.timerStatus {
        case .end:
            
            self.currentSecounds = self.duration
            self.timerStatus = .start
            UIView.animate(withDuration: 0.5, animations: {
                self.timerLabel.alpha = 1
                self.progressView.alpha = 1
                self.datePicker.alpha = 0
            })
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            self.startItmer()
            
        case .start :
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            self.timer?.suspend()// 타이머 일시정지
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
        }

    }
    

}

