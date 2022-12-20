//
//  ViewController.swift
//  Weather
//
//  Created by 최수훈 on 2022/12/16.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDiscription: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    
    @IBOutlet weak var weatherStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true) // 버튼눌리면 키보드 사라짐
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureView(weatherInformation: WeatherInformation) {
        self.cityNameLabel.text = weatherInformation.name
        if let weather = weatherInformation.weather.first {
            self.weatherDiscription.text = weather.description
        }
        
        self.tempLabel.text = "\(Int(weatherInformation.temp.temp - 273.15))℃"
        self.minTempLabel.text = "최저: \(Int(weatherInformation.temp.minTemp - 273.15))℃"
        self.maxTempLabel.text = "최고: \(Int(weatherInformation.temp.maxTemp - 273.15))℃"
    }
    
    
    func getCurrentWeather(cityName: String) {
        // string: 호출할 api 주소
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=ea105e9bab1ec090811504e0c3e257c5") else { return }
        
        // SessionConfiguration
        let session = URLSession(configuration: .default) // 기본세션설정
        
        // 서버로 데이터 요청하고 응답받을거다
        session.dataTask(with: url) { [weak self] data, response, error in
            // completion Handler 클로져를 이렇게 약식으로 표현 // data -> 서어베서 응답받은 데이터 , response -> HTTP 헤더와 및 상태코드와 같은 응답데이터 , error -> 요청에성공하면 nil 반환
            
            // TODO: - error Message Task
            let successRange = (200..<300) // 200 ~ 299
            
            guard let data = data, error == nil else { return }
            
            let decoder = JSONDecoder() // JSON 객체에서 data 유형의 인스턴스로 디코딩하는 객체
            if let response = response as? HTTPURLResponse, successRange.contains(response.statusCode) {
                // 응답 받은 스테이터스 확인
                
                guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) else { return } // JSON을 맵핑시켜줄 코더블 프로토콜을 준수하는 사용자 정의 타입을 넣는다. // from 은 서버에서 응답받은 data 파라미터넣는다 // decoding 실패하면 error 뱉기때문에 try 붙인다.
                
            // 네트워크는 별도 쓰레드에서 작업되고 끝나도 자동으로 메인쓰레도로 돌아오지 않는다. 따라서 메인쓰레드로 돌아올 수 있도록 작성
                DispatchQueue.main.async {
                    self?.weatherStackView.isHidden = false
                    self?.configureView(weatherInformation: weatherInformation)
                }
            } else {
                guard let errorMessage = try? decoder.decode(ErrorMessage.self, from: data) else { return }
                DispatchQueue.main.async {
                    self?.showAlert(message: errorMessage.message)
                }
                debugPrint(errorMessage)
            }
            
        }.resume() // 작업 실행
    }
    
}

