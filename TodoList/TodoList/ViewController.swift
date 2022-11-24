//
//  ViewController.swift
//  TodoList
//
//  Created by 최수훈 on 2022/11/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
    }

    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func tapAddButton(_ sender: UIBarButtonItem) {
        // alert 창 띄우기
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert // : 팝업
//                .actionSheet // 밑에서 버튼 띄우는거
        )
                                      
        let registerButton = UIAlertAction(title: "등록", style: .default, handler: { [weak self]_ in
            // weak self -> 클로저선언부에 캡쳐목록을 정의하는 이유는 클래스처럼 클로저도 참조타입 -> 클로저에서 클래스를 참조할때 강한 순환참조발생 -> 두개의 객체가 상호 참조하는 경우 강한 참조 -> 레퍼런스 카운트가 0으로 도달하지 않고 결국 메모리 누수 발생 -> 클로저 선언부에서 캡쳐목록을 정의해서 강한참조를 방지
            // alert 액션
            guard let title = alert.textFields?[0].text else { return } // alert.textFields?[0].text 가 옵셔널이면 아무것도 리턴 안함
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
        })
        
        let cancleButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancleButton)
        alert.addAction(registerButton)
        // alert에 텍필 추가하기
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "할 일을 입력해주세요"
            // 테이블 뷰 리로드해서 갱신한다.
            
        })
        self.present(alert, animated: true, completion:  nil)
    }
    
    
}


extension ViewController: UITableViewDataSource {
    
    // UITableViewDataSource 에 구현된 옵셔널이 붙지 않은 함수들 즉 필수 구현함수들이 구현되지 않으면 에러뜬다. 목록은 다음과 같다.
    // 각 세션에 표시할 행의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    // 특정세션의 n번쨰 로우를 그리는데 필요한 cell 을 반환하는 함수
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeueReusableCell 셀을 재사용한다
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        
        return cell
    }
    // 여기까지
}


