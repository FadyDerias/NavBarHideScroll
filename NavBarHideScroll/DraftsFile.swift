//
//  DraftsFile.swift
//  NavBarHideScroll
//
//  Created by Fady on 19/08/2022.
//

//extension ScrollingViewController: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let yContentOffset = scrollView.contentOffset.y
//
//        if scrollView.isScrollingUp {
//            print("Scrolling Up \(yContentOffset)")
//        } else if scrollView.isScrollingDown {
//            print("Scrolling Down \(yContentOffset)")
//        } else {
//            print("Odd Scrolling State \(yContentOffset)")
//        }
//
//        if scrollView.isScrollingDown && yContentOffset <= Constants.statusBarHeight {
//            headerViewConstraint?.update(offset: -yContentOffset)
//            headerViewConstraintOffset = -yContentOffset
//        } else if scrollView.isScrollingUp {
//            // this needs to be smoother
//            headerViewConstraint?.update(offset: 0)
//            headerViewConstraintOffset = 0.0
//        }
//        else if scrollView.isScrollingDown && headerViewConstraintOffset == 0.0 && abs(yContentOffset) <= Constants.statusBarHeight {
//            let newOffset = (Constants.statusBarHeight - yContentOffset) / Constants.statusBarHeight
//            headerViewConstraint?.update(offset: newOffset)
//            print("Should collapse: \(newOffset)")
//        }
//    }

//    func scrollOffset(y: CGFloat, expand: Bool, collapse: Bool) -> CGFloat {
//
//    }
//}

//    private var headerViewConstraint: Constraint?
//    private var headerViewConstraintOffset = 0.0
//    private var previousContentOffsetY = 0.0

//    private lazy var headerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .gray
//        return view
//    }()

//        view.addSubview(headerView)
//        headerView.snp.makeConstraints { make in
//            headerViewConstraint = make.top.equalTo(view).constraint
//            make.leading.trailing.equalTo(view)
//            make.height.equalTo(Constants.headerViewHeight + Constants.statusBarHeight)
//        }

//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offset = scrollView.contentOffset.y
//        accumulatedScroll += offset
//
//        print("Offset \(offset)")
//        print("Acumulated Scroll \(accumulatedScroll)")
//
//        if accumulatedScroll >= 0 && accumulatedScroll < 50 {
//            topConstraint?.update(offset: min(0, -accumulatedScroll))
//            //.constant = min(0, -offset)
//        }
//
//        if accumulatedScroll >= 0 && accumulatedScroll < 100 {
//            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -accumulatedScroll))
//            scrollView.contentOffset = .zero
//        }
//
//        let scrollVelocity = collectionView.panGestureRecognizer.velocity(in: collectionView.superview).y
//
//        if scrollVelocity > 0 {
//            print("Direction Down \(scrollVelocity)")
//        } else if scrollVelocity < 0 {
//            print("Direction Up \(scrollVelocity)")
//        }
//
//
//        if accumulatedScroll >= 0 && accumulatedScroll < 100 {
//            topConstraint.constant = min(0, -accumulatedScroll)
//            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -accumulatedScroll))
//            scrollView.contentOffset = .zero
//        } else {
//
//        }
//
//        let safeAreaTop = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0
//        let magicalSafeAreaTop = safeAreaTop + (navigationController?.navigationBar.frame.height ?? 0) //- 100
//
//        let offset = scrollView.contentOffset.y + magicalSafeAreaTop
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//
//        topConstraint.constant = -offset
//        let segmentedMagicalSafeAreaTop: CGFloat = 30
//        let segmentedOffset = scrollView.contentOffset.y + segmentedMagicalSafeAreaTop
//        segmentedView.transform = .init(translationX: 0, y: min(0, -offset))
//        view.bringSubviewToFront(segmentedView)
//
//        let alpha: CGFloat = 1 - ((scrollView.contentOffset.y + magicalSafeAreaTop) / magicalSafeAreaTop)
//        titleView.alpha = alpha
//            didScroll(yOffset: collectionView.contentOffset.y, yTranslation: collectionView.yTranslation)
//            collectionView.contentOffset = .zero
//    }
