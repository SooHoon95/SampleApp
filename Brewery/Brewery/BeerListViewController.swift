//
//  BeerListViewController.swift
//  Brewery
//
//  Created by 최수훈 on 2023/01/28.
//

import UIKit


class BeerListViewController : UITableViewController {
    
    var beerList = [Beer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UiNavigationBar
        
        title = "패캠브루어리"
        navigationController?.navigationBar.prefersLargeTitles = true // 큰 타이틀 형태
        
        //UITableView 설정
        tableView.register(BeerListCell.self, forCellReuseIdentifier: "BeerListCell")
        tableView.rowHeight = 150
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
