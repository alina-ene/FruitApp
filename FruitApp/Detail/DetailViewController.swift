//
//  DetailViewController.swift
//  FruitApp
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, Storyboarded {
    
    @IBOutlet private var stackView: UIStackView!
    var presenter: DetailViewPresentable!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...presenter.fruitDetailCount-1 {
            let label = UILabel()
            label.text = presenter.text(for: i)
            label.font = UIFont(name: "MarkerFelt-Thin", size: 30)
            label.textColor = .white
            stackView.addArrangedSubview(label)
        }
        
        
        //testing the crash reporting delegate - uncomment to crash the app and see if error stat gets sent
//        self.perform("crashme:", with: nil, afterDelay: 10)
    }
}
