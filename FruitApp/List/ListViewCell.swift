//
//  ListViewCell.swift
//  FruitApp
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

protocol ReusableView: class {
    static var identifier: String { get }
}

extension ReusableView where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView {
}

class ListViewCell: UITableViewCell {
    
    @IBOutlet private var titleLabel: UILabel!
    
    var fruitName: String? {
        didSet {
            titleLabel.text = fruitName
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        let customBackgroundView = UIView(frame: frame)
        customBackgroundView.backgroundColor = .systemTeal
        selectedBackgroundView = customBackgroundView
    }
    
}
