//
//  HomeViewController.swift
//  NetflixStyleSampleApp
//
//  Created by 최수훈 on 2023/01/14.
//

import UIKit
import SwiftUI


class HomeViewController: UICollectionViewController {
    
    var contents: [Content] = []
    // 실제로 Cotent.plist의 데이터를 가져오기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 설정
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) // 빈 UIImage로 놓는다
        navigationController?.navigationBar.shadowImage = UIImage() // 그림자를 줘서 투명하지만 경계 확인 가능하게
        navigationController?.hidesBarsOnSwipe = true // 실제로 table , collection Swipe 할때 안보이게
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(imageLiteralResourceName: "netflix_icon"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
        
        // MARK: - Data 설정, 가져오기
        contents = getContents()
        
        // MARK: - CollectinoView Item(Cell)설정
        collectionView.register(ContentCollectionViewCell.self, forCellWithReuseIdentifier: "ContentCollectionViewCell")
        
        // Header
        // 헤더는 Cell 이 아니라 supplementalryView 라고 알려줘야함
        // 따라서 forCellWithReuseIdentifier 이 아니라 forSupplementaryViewOfKind 써야한다.
        collectionView.register(ContentCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ContentCollectionViewHeader")
        
    }
    
    
    func getContents() -> [Content] {
        guard let path = Bundle.main.path(forResource: "Content", ofType: "plist"), // content.plist 의 경로
              let data = FileManager.default.contents(atPath: path), // 어디에 있는 컨텐츠야?
              let list = try? PropertyListDecoder().decode([Content].self, from: data) else { return [] }
        
        return list
    }
}

// UICollectionView DataSource, Delegate
extension HomeViewController {
    // 섹션당 보여질 셀의 갯수
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return contents[section].contentItem.count
        }
    }
    
    // 콜렉션뷰 셀 설정
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch contents[indexPath.section].sectionType {
        case .basic, .large:
            // 만들어둔 셀 적용
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as? ContentCollectionViewCell else { return UICollectionViewCell() }
            
            cell.imageView.image = contents[indexPath.section].contentItem[indexPath.row].image
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    // 헤더 뷰 설정
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ContentCollectionViewHeader", for: indexPath) as? ContentCollectionViewHeader else { fatalError("Could not dequeue Header")}
            
            headerView.sectionNameLabel.text = contents[indexPath.section].sectionname
            return headerView
        } else {
            return UICollectionReusableView() // 그냥 긴 리유저블 뷰 보내줘
        }
    }
    
    // 섹션 갯수 설정
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contents.count
    }
    
    // 셀 선택
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionName = contents[indexPath.section].sectionname
        print("TEST: \(sectionName)섹션의 \(indexPath.row + 1) 번째 콘텐츠")
    }
}


//Swift UI를 활용한 미리 보기
struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        Container().edgesIgnoringSafeArea(.all)
    }
    
    struct Container: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> UIViewController {
            let layout = UICollectionViewLayout()
            let homeViewController = HomeViewController(collectionViewLayout: layout)
            return UINavigationController(rootViewController: homeViewController)
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
        
        typealias UIViewControllerType = UIViewController
    }
}

