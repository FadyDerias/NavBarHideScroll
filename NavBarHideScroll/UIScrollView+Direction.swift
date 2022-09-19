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

    var didTranslateUp: Bool {
        panGestureRecognizer.translation(in: superview).y > 0
    }

    var didTranslateDown: Bool {
        panGestureRecognizer.translation(in: superview).y < 0
    }

    var didScrollUp: Bool {
        panGestureRecognizer.velocity(in: self).y > 0
    }
}

