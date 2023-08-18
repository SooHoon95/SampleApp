//
//  BeerListViewController.swift
//  Brewery
//
//  Created by 최수훈 on 2023/01/28.
//

import UIKit


class BeerListViewController : UITableViewController {
    
    var beerList = [Beer]()
    var dataTasks = [URLSessionTask]()
    // 페이지 기반으로 불러옴
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UiNavigationBar
        
        title = "Brewery"
        navigationController?.navigationBar.prefersLargeTitles = true // 큰 타이틀 형태
        
        //UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
        tableView.prefetchDataSource = self
        
        fetchBeer(of: currentPage)
    }
    
}

// datasource, delegate
extension BeerListViewController: UITableViewDataSourcePrefetching {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beerList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Rows \(indexPath.row)")
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
    
    
    // prefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            guard currentPage != 1 else { return } // 최소 2번째 부터 불러온다.
        
        indexPaths.forEach {
            if ($0.row + 1)/25 + 1 == currentPage {
                self.fetchBeer(of: currentPage)
            }
        }
    }
}


// Data Fetching
private extension BeerListViewController {
    
    func fetchBeer(of page: Int) {
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?page=\(page)"),
        dataTasks.firstIndex(where: { $0.originalRequest?.url == url }) == nil // 한번이라도 들어왔던 url 이라면 false 리턴한다
        else { return }
        
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
        dataTasks.append(dataTask)
    }
}
