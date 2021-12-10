//
//  SquareViewController.swift
//  Background
//
//  Created by Luís Filipe Nascimento on 05/12/21.
//

import UIKit

class SquareViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    var models:[Int]!
    var numberOfItems = 5
    var columnLayout:ColumnFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Grid com accessibility"
        setupModels()
        setupCollectionView()
        NotificationCenter.default.addObserver(self, selector: #selector(detectouMudancaDeFonte), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    func setupCollectionView() {
        columnLayout = ColumnFlowLayout(
            cellsPerRow: numberOfItems,
            minimumInteritemSpacing: 8,
            minimumLineSpacing: 8,
            sectionInset: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        )
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: columnLayout)
        configureLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: SquareCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: SquareCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor(red: 242 / 256, green: 242 / 256, blue: 251 / 256, alpha: 1)
        self.view.addSubview(collectionView)
    }
    
    func configureLayout() {
        verificaTamanhoDaFonte()
        columnLayout = ColumnFlowLayout(
            cellsPerRow: numberOfItems,
            minimumInteritemSpacing: 8,
            minimumLineSpacing: 8,
            sectionInset: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        )
        collectionView.collectionViewLayout = columnLayout
        collectionView.contentInsetAdjustmentBehavior = .always
    }
    
    func setupModels() {
        models = Array(1...100)
    }
    
    @objc func detectouMudancaDeFonte() {
        configureLayout()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func verificaTamanhoDaFonte() {
        if UIApplication.shared.preferredContentSizeCategory < UIContentSizeCategory.extraLarge {
            numberOfItems = 5
        } else if UIApplication.shared.preferredContentSizeCategory < UIContentSizeCategory.accessibilityLarge {
            numberOfItems = 4
        } else {
            numberOfItems = 3
        }
    }
}

extension SquareViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquareCollectionViewCell.identifier, for: indexPath) as! SquareCollectionViewCell
        
        cell.configure(with: models[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
}

class ColumnFlowLayout: UICollectionViewFlowLayout {
    
    let cellsPerRow: Int
    
    init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
        self.cellsPerRow = cellsPerRow
        super.init()
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        let marginsAndInsets = sectionInset.left + sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
        context.invalidateFlowLayoutDelegateMetrics = newBounds.size != collectionView?.bounds.size
        return context
    }
}
