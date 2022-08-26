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

    private var isNavBarVisible = true
    private var topConstraint: Constraint?

    private var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }

    private var navigationBarHeight: CGFloat {
        let safeAreaTop = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0
        return safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0)
    }

    private var totalNavigationViewHeight: CGFloat {
        return statusBarHeight + navigationBarHeight
    }

    private var isNavigationBarHidden: Bool {
        return navigationController?.isNavigationBarHidden ?? false
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

extension ScrollingViewController {
    @objc func handleCollectionViewTap(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .recognized: didEndScrollviewDrag()
        case .changed: didChangeDrag()
        case .began, .cancelled, .ended, .possible, .failed: return
        @unknown default: print("@unknown Drag Error")
        }
    }

    private func didEndScrollviewDrag() {
        print("Recognized Drag")

        if collectionView.isScrollingDown && isNavBarVisible {
            didEndDraggingDown(yTranslation: collectionView.yTranslation)
        } else if collectionView.isScrollingUp && !isNavBarVisible {
            didEndDraggingUp(yTranslation: collectionView.yTranslation)
        }
    }

    private func didChangeDrag() {
        print("Changed Drag \(collectionView.yTranslation)")

        if collectionView.isScrollingDown && isNavBarVisible {
            didScrollDown(yOffset: collectionView.contentOffset.y, yTranslation: collectionView.yTranslation)
        } else if collectionView.isScrollingUp && !isNavBarVisible {
            didScrollUp(yOffset: collectionView.contentOffset.y, yTranslation: collectionView.yTranslation)
        }
    }
}

private extension ScrollingViewController {
    func didScrollDown(yOffset: CGFloat, yTranslation: CGFloat) {
        print("Down Scroll: yTranslation: \(yTranslation) yOffset: \(yOffset)")
        isNavBarVisible = yTranslation < totalNavigationViewHeight
        animateHidingNavigationBar(yTranslation: yTranslation)
    }

    func didScrollUp(yOffset: CGFloat, yTranslation: CGFloat) {
        guard yOffset <= totalNavigationViewHeight else {
            return
        }
        print("Up Scroll: yTranslation: \(yTranslation) yOffset: \(yOffset)")
        isNavBarVisible = abs(yTranslation) < totalNavigationViewHeight
        animateHidingNavigationBar(yTranslation: yTranslation)
    }

    func animateHidingNavigationBar(yTranslation: CGFloat) {
        if abs(yTranslation) <= totalNavigationViewHeight {
            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, yTranslation))
        }

        if abs(yTranslation) <= statusBarHeight {
            topConstraint?.update(offset: min(0, yTranslation))
        }

        titleView.alpha = 1 - (abs(yTranslation) / 100)
    }

    func didEndDraggingUp(yTranslation: CGFloat) {
        abs(yTranslation) >= 25 ? showSearchBar() : hideSearchBar()
    }

    func didEndDraggingDown(yTranslation: CGFloat) {
        abs(yTranslation) >= 25 ? hideSearchBar() : showSearchBar()
    }
}

private extension ScrollingViewController {
    func showSearchBar() {
        print("Force Show Search Bar")
        titleView.alpha = 1

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear, .allowUserInteraction]) { [weak self] in
            self?.showSegmentedView()
            self?.showNavigationBar()
            self?.view.layoutIfNeeded()
        } completion: { [weak self] completed in
            self?.isNavBarVisible = true
        }
    }

    func hideSearchBar() {
        print("Force Hide Search Bar")
        titleView.alpha = 0

        UIView.animate(withDuration: 0.0, delay: 0, options: [.curveLinear, .allowUserInteraction]) { [weak self] in
            self?.scrollSegmentedViewToTop()
            self?.hideNavigationBar()
            self?.view.layoutIfNeeded()
        } completion: { [weak self] completed in
            self?.isNavBarVisible = false
        }
    }

    func showNavigationBar() {
        navigationController?.navigationBar.transform = .identity
    }

    func hideNavigationBar() {
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -totalNavigationViewHeight)
    }

    func scrollSegmentedViewToTop() {
        topConstraint?.update(offset: -statusBarHeight)
    }

    func showSegmentedView() {
        topConstraint?.update(offset: 0)
    }
}
