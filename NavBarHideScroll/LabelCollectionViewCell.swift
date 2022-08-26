//
//  LabelTableViewCell.swift
//  NavBarHideScroll
//
//  Created by Fady on 17/08/2022.
//

import UIKit
import SnapKit

class LabelCollectionViewCell: UICollectionViewCell {

    static let reuseIdentitifer = "LabelTableViewCellIdentifier"
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.numberOfLines = 1
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.centerY.equalTo(contentView)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LabelCollectionViewCell {
    func configure(title: String, bgColor: UIColor) {
        titleLabel.text = title
        backgroundColor = bgColor
    }
}
