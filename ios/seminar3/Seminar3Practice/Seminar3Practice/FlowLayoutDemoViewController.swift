//
//  FlowLayoutDemoViewController.swift
//  Seminar3Practice
//
//  Created by user on 2023/10/29.
//

import UIKit

class FlowLayoutDemoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
    private var demo = EraseToAnyPublisherDemo()
    override func viewDidLoad() {
        super.viewDidLoad()
        demo.start()
        setupCollectionView()
    }

    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 20

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout (optional, if you want to adjust sizes dynamically)

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)  // Can adjust this dynamically based on content or index
    }
}
