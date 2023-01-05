//
//  AlertListViewController.swift
//  Drink
//
//  Created by 최수훈 on 2023/01/05.
//

import UIKit

class AlertListViewController: UITableViewController {
    
    var alerts: [Alert] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Cell 등록
        let nibName = UINib(nibName: "AlertListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AlertListCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        alerts = alertList()
    }
    
    
    @IBAction func addAlertButton(_ sender: UIBarButtonItem) {
        guard let addAlertVC = storyboard?.instantiateViewController(identifier: "AddAlertViewController") as? AddAlertViewController else { return }
        
        addAlertVC.pickedDate = { [ weak self] date in // 클로저니까
            guard let self = self else { return }
            
            var alertList = self.alertList() // 우리가 방금 userdefualts 에서 있는 현재 리스트들
            let newAlert = Alert(date: date, isOn: true)
            
            alertList.append(newAlert)  // 생성된 데이터를 리스트에 더해준다.
            alertList.sorted { $0.date < $1.date } // 시간순서대로
            
            
            self.alerts = alertList     // 새로운 리스트로 덮어쓰기
            // userDefaults에 새로운 값 다시 넣어주기
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts") // 인코딩
            self.tableView.reloadData() // 테이블 뷰 리로드
        }
        
        self.present(addAlertVC, animated: true)
    }
    
    // Userdefaults 에서 가져오기
    func alertList() -> [Alert] {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              let alerts = try? PropertyListDecoder().decode( [Alert].self , from: data) else { return [] } // 디코딩
        
        return alerts
    }
}



// UITableView dataSource Delegate
extension AlertListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alerts.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "💦 물마실 시간"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertListCell", for: indexPath) as? AlertListCell else { return UITableViewCell() }
        
        cell.alertSwich.isOn = alerts[indexPath.row].isOn
        cell.timeLabel.text = alerts[indexPath.row].time
        cell.meridiemLabel.text = alerts[indexPath.row].merdiem
        
        // tah 값을 줘서 싀위치 상태 제어
        cell.alertSwich.tag = indexPath.row
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            // notification 삭제 구현
            self.alerts.remove(at: indexPath.row)   // 해당 로우에 데이터 삭제
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.alerts), forKey: "alerts") // 지워준 리스트를 다시 덮어씌운다.
            self.tableView.reloadData()
            return
        default:
            break

        }
    }
}
