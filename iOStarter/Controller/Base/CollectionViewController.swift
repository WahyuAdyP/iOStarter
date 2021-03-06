//
//  CollectionViewController.swift
//  iOStarter
//
//  Created by Crocodic Studio on 09/12/19.
//  Copyright © 2019 WahyuAdyP. All rights reserved.
//

import UIKit

class CollectionViewController: ViewController {

    @IBOutlet weak private(set) var collectionView: UICollectionView!
    
    private(set) var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupMethod() {
        super.setupMethod()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
    }
    
    override func setupView() {
        super.setupView()
        
        collectionView.addSubview(refreshControl)
    }
    
    @objc override func fetch() {
        super.fetch()
        
        fetch(isLoadMore: false)
    }
    
    /// Fetch list data
    @objc func fetch(isLoadMore: Bool = false) {
        
    }
}

extension CollectionViewController {
    /// Indicate that list can load more
    @objc open var canLoadMore: Bool {
        return false
    }
    
    /// Number of items property of data list
    @objc open var numberOfItems: Int {
        fatalError("Number items method not defined")
    }
    
    /// Instantiate cell identifier to tableview list
    ///
    /// - Parameters:
    ///   - collectionView: Collection view container
    ///   - indexPath: Indexpath position of cell
    /// - Returns: Tableviewcell that has instantiate
    @objc open func cellOfItem(_ collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        fatalError("Cell collectionView not set")
    }
    
    /// Did select table view item
    ///
    /// - Parameters:
    ///   - collectionView: Collection view container
    ///   - indexPath: Indexpath position of cell
    @objc open func didSelect(_ collectionView: UICollectionView, at indexPath: IndexPath) {
        
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellOfItem(collectionView, at: indexPath)
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect(collectionView, at: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = offset.y + bounds.size.height - inset.bottom
        let h = size.height
        let reload_distance:CGFloat = 20.0
        if y > (h + reload_distance) {
            if canLoadMore {
                fetch(isLoadMore: true)
            }
        }
    }
}
