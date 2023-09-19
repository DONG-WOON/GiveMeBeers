//
//  BeerCollectionViewController.swift
//  GiveMeBeers
//
//  Created by 서동운 on 8/8/23.
//

import UIKit

class BeerCollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var beerList: [Beer] = []
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = BeerCollectionViewLayout()
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.delegate = self
        
        getBeer(page: page)
    }
    
    @IBAction func recommendButtonDidTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: BeerDetailViewController.identifier) as! BeerDetailViewController
        vc.scene = .recommend
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getBeer(page: Int) {
        BeerApiManager.shared.request(type: [Beer].self, api: .getBeers(page)) { result in
            switch result {
            case .success(let beers):
                self.beerList.append(contentsOf: beers)
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension BeerCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return beerList.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeerCollectionViewCell.identifier, for: indexPath) as? BeerCollectionViewCell else { return UICollectionViewCell() }
        cell.update(data: beerList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: BeerDetailViewController.identifier) as! BeerDetailViewController
        vc.scene = .detail
        vc.beer = beerList[indexPath.item]
        present(vc, animated: true)
    }
}

// MARK: Prefetch

extension BeerCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.item == beerList.count - 1 }) {
            page += 1
            print("🔥 ",#function)
            getBeer(page: page)
        }
    }
}

class BeerCollectionViewLayout: UICollectionViewCompositionalLayout {
    init() {
        let spacing: CGFloat = 3
        let layoutItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),
                                                heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: layoutItemSize)
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1 / 5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spacing, bottom: 0, trailing: spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        super.init(section: section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

