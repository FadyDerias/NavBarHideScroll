//
//  UIScrollView+Direction.swift
//  NavBarHideScroll
//
//  Created by Fady on 18/08/2022.
//

import UIKit

extension UIScrollView {
    var scrollingVelocity: CGFloat {
        return panGestureRecognizer.velocity(in: self).y
    }

    var yTranslation: CGFloat {
        panGestureRecognizer.translation(in: self).y
    }

    var isScrollingUp: Bool {
//        return panGestureRecognizer.velocity(in: superview).y > 0
        panGestureRecognizer.translation(in: superview).y > 0
    }

    var isScrollingDown: Bool {
//        return panGestureRecognizer.velocity(in: superview).y < 0
        panGestureRecognizer.translation(in: superview).y < 0
    }

//    var yTranslation: CGFloat {
//        panGestureRecognizer.translation(in: superview).y 
//    }
}

