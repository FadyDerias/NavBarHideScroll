//
//  ViewController.swift
//  NavBarHideScroll
//
//  Created by Fady on 17/08/2022.
//

import UIKit
import SnapKit

class ScrollingViewController: UIViewController {
    private let titleView = TitleSearchView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let segmentedView = UIView()
    private var scrollingValue = 0.0

    private var isNavBarVisible = true
    private var topConstraint: Constraint?
    private var lastContentOffset: CGPoint = .zero

    private var navigationBarHeight: CGFloat {
        return navigationController?.navigationBar.frame.height ?? 0.0
    }

    private var isNavBarRestored: Bool {
        return navigationController?.navigationBar.transform == .identity
    }

    private var shouldTranslateDown: Bool {
        return isNavBarVisible || isNavBarRestored
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan

        titleView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 30)
        navigationItem.titleView = titleView

        segmentedView.backgroundColor = .green
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { make in
            topConstraint = make.top.equalTo(view.safeAreaLayoutGuide.snp.top).constraint
            make.leading.trailing.equalTo(view)
            make.height.equalTo(30)
        }

        setupCollectionView()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view)
        }
    }

    private func setupCollectionView() {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.minimumInteritemSpacing = 0
        collectionViewFlowLayout.minimumLineSpacing = 0
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 70)
        //Setting the estimatedItemSize fixes flickering happening when animating force hide / show of the navigation bar & segmented view
        collectionViewFlowLayout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 70)

        collectionView.collectionViewLayout = collectionViewFlowLayout
        collectionView.dataSource = self
        collectionView.backgroundColor = .yellow
        collectionView.clipsToBounds = true
        collectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: LabelCollectionViewCell.reuseIdentitifer)

        collectionView.panGestureRecognizer.addTarget(self, action: #selector(self.handleCollectionViewTap(_:)))
    }
}

extension ScrollingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 400
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelCollectionViewCell.reuseIdentitifer, for: indexPath) as! LabelCollectionViewCell
        cell.configure(title: "Cell Index: \(indexPath.row)", bgColor: .brown)
        return cell
    }
}

private extension ScrollingViewController {
    @objc func handleCollectionViewTap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .began: lastContentOffset = collectionView.contentOffset
        case .recognized, .failed: didEndScrollviewDrag()
        case .changed: didChangeDrag()
        case .possible, .cancelled, .ended: return
        @unknown default: return
        }
    }

    func didEndScrollviewDrag() {
        if collectionView.didTranslateDown {
            didEndDragDown()
        } else if collectionView.didScrollUp && !isNavBarRestored {
            showNavigationBar()
        }

        scrollingValue = 0.0
    }

    func didEndDragDown() {
        if collectionView.didScrollUp {
            showNavigationBar()
        } else if isNavBarVisible {
            abs(collectionView.yTranslation) >= 25 ? hideNavigationBar { [weak self] in self?.isNavBarVisible = false } : showNavigationBar()
        }
    }

    func didChangeDrag() {
        guard abs(collectionView.scrollingVelocity) < 250 else {
            return
        }
        if collectionView.didTranslateDown && shouldTranslateDown {
            didScrollDown(yTranslation: collectionView.yTranslation)
        } else if collectionView.didTranslateUp && !isNavBarVisible {
            didScrollUp(yOffset: collectionView.contentOffset.y)
        }
    }
}

private extension ScrollingViewController {
    func didScrollUp(yOffset: CGFloat) {
        guard (0.0...navigationBarHeight).contains(yOffset) else {
            return
        }
        scrollViews(value: -yOffset)
    }

    func didScrollDown(yTranslation: CGFloat) {
        if abs(yTranslation) <= navigationBarHeight {
            collectionView.contentOffset = lastContentOffset
            scrollViews(value: yTranslation)
        } else if scrollingValue <= navigationBarHeight && abs(yTranslation) > navigationBarHeight {
            hideNavigationBar(completion: nil)
        }

        scrollingValue = abs(yTranslation)
    }

    func scrollViews(value: CGFloat) {
        guard abs(value) <= navigationBarHeight else {
            return
        }
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, value))
        topConstraint?.update(offset: min(0, value))
        titleView.alpha = min(1, 1 - (abs(value) / 50))
    }

    //Gradually scrolls back the top view with user scrolling - currently, not used
    func scrollUpCustom(yOffset: CGFloat, yTranslation: CGFloat) {
        guard yOffset > 0 else {
            return
        }
        if let transform = navigationController?.navigationBar.transform, transform.ty < 0 {
            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, scrollingValue + yTranslation))
            titleView.alpha = min(1, 1 - (abs(scrollingValue + yTranslation) / 50))
        }

        if abs(scrollingValue + yTranslation) <= navigationBarHeight && scrollingValue + yTranslation <= 0 {
            topConstraint?.update(offset: scrollingValue + yTranslation)
        }
    }
}

private extension ScrollingViewController {
    func showNavigationBar(animated: Bool = true) {
        UIView.animate(withDuration: animated ? 0.6 : 0.0, delay: 0, options: .beginFromCurrentState) { [weak self] in
            self?.resetNavigationBar()
            self?.showSegmentedView()
            self?.view.layoutIfNeeded()
            self?.titleView.alpha = 1
        } completion: { [weak self] completed in
            self?.isNavBarVisible = true
        }
    }

    func hideNavigationBar(animated: Bool = true, completion: (() -> Void)?) {
        UIView.animate(withDuration: animated ? 0.1 : 0.0, delay: 0, options: .beginFromCurrentState) { [weak self] in
            self?.scrollSegmentedViewToTop()
            self?.scrollNavigationBarToTop()
            self?.view.layoutIfNeeded()
            self?.titleView.alpha = 0
        } completion: { completed in
            if completed {
                completion?()
            }
        }
    }

    func scrollNavigationBarToTop() {
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -navigationBarHeight)
    }

    func resetNavigationBar() {
        navigationController?.navigationBar.transform = .identity
    }

    func scrollSegmentedViewToTop() {
        topConstraint?.update(offset: -navigationBarHeight)
    }

    func showSegmentedView() {
        topConstraint?.update(offset: 0)
    }
}
