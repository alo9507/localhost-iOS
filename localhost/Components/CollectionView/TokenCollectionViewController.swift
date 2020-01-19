import UIKit

protocol TokenCollectionViewControllerDataSource {
    func tokenCollectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func tokenCollectionView(_ collectionView: UICollectionView, labelForItemAt indexPath: IndexPath) -> String
}

protocol TokenCollectionViewControllerDelegate {
    func tokenCollectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

class TokenCollectionViewController: NSObject {
    
    let collectionView: UICollectionView
    let dataSource: TokenCollectionViewControllerDataSource
    let delegate: TokenCollectionViewControllerDelegate
    let isSelectable: Bool
    
    init(collectionView: UICollectionView, dataSource: TokenCollectionViewControllerDataSource, delegate: TokenCollectionViewControllerDelegate, isSelectable: Bool = false) {
        self.collectionView = collectionView
        self.dataSource = dataSource
        self.delegate = delegate
        self.isSelectable = isSelectable
        super.init()
        self.setupCollectionView()
    }
    
    func setupCollectionView() {
        guard let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            fatalError("Collection view must use a flow layout.")
        }
        
        let cellNib = UINib(nibName: "TokenCollectionViewCell", bundle: nil)
        
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "cell")
        
        if isSelectable {
            self.collectionView.allowsSelection = true
            self.collectionView.allowsMultipleSelection = true
        }
        
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
}

extension TokenCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.tokenCollectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TokenCollectionViewCell
        
        if isSelectable {
            let selectedBackgroundView = UIView(frame: cell.frame)
            selectedBackgroundView.backgroundColor = UIColor.init(hexString: "#31CAFF")
            cell.selectedBackgroundView = selectedBackgroundView
        }
        
        cell.label.text = self.dataSource.tokenCollectionView(collectionView, labelForItemAt: indexPath)
        return cell
    }
}

extension TokenCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate.tokenCollectionView(collectionView, didSelectItemAt: indexPath)
    }
}
