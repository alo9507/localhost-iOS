//
//  GenericCollectionViewController.swift
//  ShoppingApp
//
//  Created by Florian Marcu on 10/15/17.
//  Copyright © 2017 iOS App Templates. All rights reserved.
//

import UIKit
import SwiftUI

protocol GenericFirebaseParsable {
    init(key: String, jsonDict: [String: Any])
}

protocol GenericCollectionViewControllerDataSourceDelegate: class {
    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadFirst objects: [GenericBaseModel])
    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadBottom objects: [GenericBaseModel])
    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadTop objects: [GenericBaseModel])
}

protocol GenericCollectionViewScrollDelegate: class {
    func genericScrollView(_ scrollView: UIScrollView, didScrollToPage page: Int)
}

protocol GenericCollectionViewControllerDataSource: class {
    var delegate: GenericCollectionViewControllerDataSourceDelegate? {get set}

    func object(at index: Int) -> GenericBaseModel?
    func numberOfObjects() -> Int

    func loadFirst()
    func loadBottom()
    func loadTop()
}

protocol GenericCollectionRowAdapter: class {
    func configure(cell: UICollectionViewCell, with object: GenericBaseModel)
    func cellClass() -> UICollectionViewCell.Type
    func size(containerBounds: CGRect, object: GenericBaseModel) -> CGSize
}

class AdapterStore {
    fileprivate var store = [String: GenericCollectionRowAdapter]()

    func add(adapter: GenericCollectionRowAdapter, for classString: String) {
        store[classString] = adapter
    }

    func adapter(for classString: String) -> GenericCollectionRowAdapter? {
        return store[classString]
    }
}

struct GenericCollectionViewControllerConfiguration {
    let pullToRefreshEnabled: Bool
    let pullToRefreshTintColor: UIColor
    let collectionViewBackgroundColor: UIColor
    let collectionViewLayout: LHCollectionViewFlowLayout
    let collectionPagingEnabled: Bool
    let hideScrollIndicators: Bool
    let hidesNavigationBar: Bool
    let headerNibName: String?
    let scrollEnabled: Bool
    let uiConfig: UIGenericConfigurationProtocol
    let emptyViewModel: CPKEmptyViewModel?
}

typealias CollectionViewSelectionBlock = (UINavigationController?, GenericBaseModel, IndexPath) -> Void

/* A generic view controller, that encapsulates:
 * - fetching data from a data store (over the network, firebase, local cache, etc)
 * - adapting a model type to a cell type
 * - persisiting data on disk
 * - manages pagination
 */
class GenericCollectionViewController: UICollectionViewController, GenericCollectionViewControllerDataSourceDelegate {
    var genericDataSource: GenericCollectionViewControllerDataSource? {
        didSet {
            genericDataSource?.delegate = self
        }
    }

    weak var scrollDelegate: GenericCollectionViewScrollDelegate?

    fileprivate var adapterStore = AdapterStore()
    let configuration: GenericCollectionViewControllerConfiguration

    fileprivate lazy var refreshControl = UIRefreshControl()
    
    @available(iOS 13.0, *)
    fileprivate lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    fileprivate lazy var emptyView: UIHostingController<CPKEmptyView>? = nil

    var selectionBlock: CollectionViewSelectionBlock?

    init(configuration: GenericCollectionViewControllerConfiguration, selectionBlock: CollectionViewSelectionBlock? = nil) {
        self.configuration = configuration
        self.selectionBlock = selectionBlock
        let layout = configuration.collectionViewLayout
        super.init(collectionViewLayout: layout)
        layout.delegate = self
        self.use(adapter: CarouselAdapter(uiConfig: configuration.uiConfig), for: "CarouselViewModel")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let collectionView = collectionView else {
            fatalError()
        }

        collectionView.backgroundColor = configuration.collectionViewBackgroundColor
        collectionView.isPagingEnabled = configuration.collectionPagingEnabled
        collectionView.isScrollEnabled = configuration.scrollEnabled
        registerReuseIdentifiers()
        if configuration.pullToRefreshEnabled {
            collectionView.addSubview(refreshControl)
            refreshControl.tintColor = configuration.pullToRefreshTintColor
            refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        }
        if configuration.hideScrollIndicators {
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
        }
        if #available(iOS 13.0, *) {
            activityIndicator.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.minY + 50)
            activityIndicator.startAnimating()
            collectionView.addSubview(activityIndicator)
        } else {
            print("❌❌❌iOS 13 NEEDED TO SHOW THE ACTIVITY INDICATOR!❌❌❌")
        }

        genericDataSource?.loadFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (configuration.hidesNavigationBar) {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (configuration.hidesNavigationBar) {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    func use(adapter: GenericCollectionRowAdapter, for classString: String) {
        adapterStore.add(adapter: adapter, for: classString)
    }

    func registerReuseIdentifiers() {
        adapterStore.store.forEach { (key, adapter) in  
            collectionView?.register(UINib(nibName: String(describing: adapter.cellClass()), bundle: nil), forCellWithReuseIdentifier: key)
        }
        if let headerNib = configuration.headerNibName {
            collectionView?.register(UINib(nibName: headerNib, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerNib)
        }
    }

    func handleEmptyViewCallToAction() {
        // To be overriden by subclasses
    }

    // MARK: - GenericCollectionViewControllerDataSourceDelegate
    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadFirst objects: [GenericBaseModel]) {
        self.reloadCollectionView()
        // on add load this does get called with the right matches
        // but is not called when the view loads
    }

    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadBottom objects: [GenericBaseModel]) {
        let offset = dataSource.numberOfObjects() - objects.count
        self.collectionView?.performBatchUpdates({
            let indexPaths = (0 ..< objects.count).map({ IndexPath(row: offset + $0, section: 0)})
            self.collectionView?.insertItems(at: indexPaths)
        }, completion: nil)
        self.updateAfterLoad()
    }

    func genericCollectionViewControllerDataSource(_ dataSource: GenericCollectionViewControllerDataSource, didLoadTop objects: [GenericBaseModel]) {
        if (configuration.pullToRefreshEnabled) {
            refreshControl.endRefreshing()
        }
        self.reloadCollectionView()
    }

    private func reloadCollectionView() {
        assert(Thread.isMainThread)
        if let liquidLayout = self.collectionView?.collectionViewLayout as? LHLiquidCollectionViewLayout {
            liquidLayout.invalidateCache()
        }
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
        if let parent = self.parent as? GenericCollectionViewController {
            parent.reloadCollectionView()
        }
        self.updateAfterLoad()
    }

    private func updateAfterLoad() {
        if #available(iOS 13.0, *) {
            activityIndicator.stopAnimating()
        } else {
            print("❌❌❌iOS 13 NEEDED TO SHOW THE ACTIVITY INDICATOR!❌❌❌")
        }
        guard let emptyViewModel = configuration.emptyViewModel else { return }
        if ((genericDataSource?.numberOfObjects() ?? 0) == 0) {
            let bounds = self.collectionView.bounds
            if emptyView == nil {
                var uiView = CPKEmptyView(model: emptyViewModel)
                uiView.handler = self
                emptyView = UIHostingController(rootView: uiView)
            }
            guard let emptyView = emptyView else { return }
            // this may be why the empty view isn't showing
            self.addChildViewControllerWithView(emptyView, toView: self.collectionView)
            emptyView.view.frame = bounds
        } else {
            emptyView?.view.removeFromSuperview()
            emptyView?.removeFromParent()
        }
    }

    // MARK: - Private

    private func size(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        if let adapter = self.adapter(at: indexPath), let object = genericDataSource?.object(at: indexPath.row) {
            return adapter.size(containerBounds: collectionView.bounds, object: object)
        }
        return .zero
    }

    private func adapter(at indexPath: IndexPath) -> GenericCollectionRowAdapter? {
        if let object = genericDataSource?.object(at: indexPath.row) {
            let stringClass = String(describing: type(of: object))
            if let adapter = adapterStore.adapter(for: stringClass) {
                return adapter
            }
        }
        return nil
    }

    @objc func didPullToRefresh() {
        genericDataSource?.loadTop()
    }
}

extension GenericCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let object = genericDataSource?.object(at: indexPath.row) {
            let stringClass = String(describing: type(of: object))
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: stringClass, for: indexPath)
            if let adapter = adapterStore.adapter(for: stringClass) {
                adapter.configure(cell: cell, with: object)
            }
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectionBlock = selectionBlock,
            let object = genericDataSource?.object(at: indexPath.row) {
            let navController = self.findNavigationController()
            selectionBlock(navController, object, indexPath)
        }
    }

    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genericDataSource?.numberOfObjects() ?? 0
    }

    override open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 >= (genericDataSource?.numberOfObjects() ?? 0) {
            genericDataSource?.loadBottom()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionView.elementKindSectionHeader) {
            let id = configuration.headerNibName ?? "header"
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath)
            return head
        } else if (kind == UICollectionView.elementKindSectionFooter) {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)
        }
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let _ = configuration.headerNibName {
            return CGSize(width: 75, height: 100)
        }
        return CGSize.zero
    }
}

extension GenericCollectionViewController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        if w != 0 {
            let page = Int(ceil(x/w))
            scrollDelegate?.genericScrollView(scrollView, didScrollToPage: page)
        }
    }
}

extension GenericCollectionViewController: LiquidLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath, width: CGFloat) -> CGFloat {
        return self.size(collectionView: collectionView, indexPath: indexPath).height
    }

    func collectionViewCellWidth(collectionView: UICollectionView) -> CGFloat {
        return self.size(collectionView: collectionView, indexPath: IndexPath(row: 0, section: 0)).width
    }
}

extension GenericCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.size(collectionView: collectionView, indexPath: indexPath)
    }
}

extension GenericCollectionViewController: CPKEmptyViewHandler {
    func didTapActionButton() {
        handleEmptyViewCallToAction()
    }
}
