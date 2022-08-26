//  Copyright © 2021 Snapwise Inc. All rights reserved.

import UIKit

class TitleSearchView: UIView {
    private lazy var searchBar: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .lightGray
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        label.text = "Search"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.edges.equalTo(self)
            make.width.equalTo(240)
            make.height.equalTo(32)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
