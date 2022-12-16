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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tapFetchWeatherButton(_ sender: UIButton) {
        if let cityName = self.cityNameTextField.text {
            self.getCurrentWeather(cityName: cityName)
            self.view.endEditing(true) // 버튼눌리면 키보드 사라짐
        }
    }
    
    
    func getCurrentWeather(cityName: String) {
        // string: 호출할 api 주소
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=ea105e9bab1ec090811504e0c3e257c5") else { return }
        
        // SessionConfiguration
        let session = URLSession(configuration: .default) // 기본세션설정
        
        // 서버로 데이터 요청하고 응답받을거다
        session.dataTask(with: url) { data, response, error in
            // completion Handler 클로져를 이렇게 약식으로 표현 // data -> 서어베서 응답받은 데이터 , response -> HTTP 헤더와 및 상태코드와 같은 응답데이터 , error -> 요청에성공하면 nil 반환
            
            guard let data = data, error == nil else { return }
            let decoder = JSONDecoder() // JSON 객체에서 data 유형의 인스턴스로 디코딩하는 객체
            let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data) // JSON을 맵핑시켜줄 코더블 프로토콜을 준수하는 사용자 정의 타입을 넣는다. // from 은 서버에서 응답받은 data 파라미터넣는다 // decoding 실패하면 error 뱉기때문에 try 붙인다.
        debugPrint(weatherInformation)
            
        }.resume() // 작업 실행
    }
    
}

