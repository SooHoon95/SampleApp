//
//  ViewController.swift
//  COVID19
//
//  Created by 최수훈 on 2022/12/20.
//

import Alamofire

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var totlaCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchCovidOverview() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                debugPrint("success \(result)")
            case let .failure(error):
                debugPrint("fail \(error)")
            }
        }
    }
    
    func fetchCovidOverview (
    // api 요청하고 데이터 응답받거나 실패했을때 이 클로저를 호출해 해당 클로저를 정의하는 곳에 응답받은 데이터를 정의한다.
        completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void   // 첫번째 T : 성공했을때 전달 받을 타입, 두번째 : 실패했을때, 반환값없음
    ) {
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey" : "2VnSi38LBdPjGkwF1UxeYzM9XloAbft7D"
        ]
        
        // Alamofire로 api 호출
        AF.request(url, method: .get, parameters: param) // parameters -> 딕셔너리 형태로 넣어주면 알아서 파싱한다.
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        // fetch 에 정의한 컴플리션핸들로 호출
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                    
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
        
        
    }
}

