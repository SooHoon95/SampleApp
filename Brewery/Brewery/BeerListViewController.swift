//
//  BeerListViewController.swift
//  Brewery
//
//  Created by 최수훈 on 2023/01/28.
//

import UIKit


class BeerListViewController : UITableViewController {
    
    var beerList = [Beer]()
    // 페이지 기반으로 불러옴
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UiNavigationBar
        
        title = "패캠브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true // 큰 타이틀 형태
        
        //UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        
        fetchBeer(of: currentPage)
    }
    
}

// datasource, delegate
extension BeerListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BeerListCell", for: indexPath) as? BeerListCell else { return UITableViewCell() }
        
        let beer = beerList[indexPath.row]
        cell.configure(with: beer)
        
        return cell
    }
    
    
    // delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBeer = beerList[indexPath.row]
        let detailViewContoller = BeerDetailViewController()
        
        detailViewContoller.beer = selectedBeer
        self.show(detailViewContoller, sender: nil)
    }
}


// Data Fetching
private extension BeerListViewController {
    
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil,
                let self = self,
                let response = response as? HTTPURLResponse,
                let data = data,
            let beers = try? JSONDecoder().decode([Beer].self, from: data) else { print("Error : URLSession data task \(error?.localizedDescription ?? "")")
                return
            }
            
            switch response.statusCode {
            case (200...299):   // 성공
                self.beerList += beers  // 배열에 넣기
                self.currentPage += 1 // page 올리기

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case (400...499):   // 클라이언트 에러
                print("""
                    Error : Client Error \(response.statusCode)
                    Response: \(response)
                """)
            case (500...599):   // 서버에러
                print("""
                    Error : Server Error \(response.statusCode)
                    Response: \(response)
                """)
            default:
                print("""
                    Error : \(response.statusCode)
                    Response: \(response)
                """)
            }
        }
        // MARK: - 반드시 resume 해줘야한다.
        dataTask.resume()
    }
}
