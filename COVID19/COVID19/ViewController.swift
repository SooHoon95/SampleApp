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
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.startAnimating()
        self.fetchCovidOverview() { [weak self] result in
            guard let self = self else { return }
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            switch result {
            case let .success(result):
                debugPrint("success \(result)")
                // Alamofire 에서는 completionHandler가 메인쓰레드에서 작동하기 때문에 따로 dispatchQue 로 메인쓰레드에 작동하도록 코드를 작성하지 않아도 된다.
                self.configureStackView(koreaCovidOverview: result.korea)
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChartView(covidOverViewList: covidOverviewList)
            case let .failure(error):
                debugPrint("fail \(error)")
            }
        }
    }
    
    // MARK: - 파이 차트 그리기
    func makeCovidOverviewList(
        cityCovidOverview: CityCovidOverview
    ) -> [CovideOverview] {
        return [
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju
        ]
    }
    
    func configureChartView(covidOverViewList: [CovideOverview]) {
        self.pieChartView.delegate = self
        // covideOverView -> PiechartDataEntry 로 맵핑
        let entries = covidOverViewList.compactMap { [ weak self ] overview -> PieChartDataEntry? in
            guard let  self = self else { return nil }
            return PieChartDataEntry(
                value: self.removeFormatString(string: overview.newCase),
                label: overview.countryName,
                data: overview
            )
        }
            let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
            dataSet.sliceSpace = 1 // 항목간 간격
            dataSet.entryLabelColor = .black
            dataSet.valueTextColor = .black
            dataSet.xValuePosition = .outsideSlice // 항목이름이 바깥쪽으로 표시됨
            dataSet.valueLinePart1OffsetPercentage = 0.8
            dataSet.valueLinePart1Length = 0.2
            dataSet.valueLinePart2Length = 0.3
        // 다양한색상으로
            dataSet.colors = ChartColorTemplates.vordiplom() +
            ChartColorTemplates.joyful() +
            ChartColorTemplates.liberty() +
            ChartColorTemplates.pastel() +
            ChartColorTemplates.material()
            self.pieChartView.data = PieChartData(dataSet: dataSet)
        // 차트 회전시키기
        self.pieChartView.spin(duration: 0.3, fromAngle: self.pieChartView.rotationAngle, toAngle: self.pieChartView.rotationAngle + 80) // 현재 앵글에서 80도 정도 회전시킨 상태
        
    }
    
    func removeFormatString(string: String) -> Double {
        // xxx,xxx,xx 에서 ,없애기
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
    
    func configureStackView(koreaCovidOverview: CovideOverview) {
        self.totlaCaseLabel.text = "\(koreaCovidOverview.totalCase)명"
        self.newCaseLabel.text = "\(koreaCovidOverview.newCase)명"
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

extension ViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        // entrie 메소드파라미터를 통해 선택된 항목을 가져올 수 있다.
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(identifier: "CovidDetailViewController") as? CovidDetailViewController else { return }
        guard let covideOverview = entry.data as? CovideOverview else { return } // downCasting
        covidDetailViewController.covidOverview = covideOverview
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}

