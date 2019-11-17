//
//  AppCoordinator.swift
//  FruitApp
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ListViewController.instantiate()
        vc.presenter = ListViewPresenter(coordinator: self)
        navigationController.pushViewController(vc, animated: false)
    }
    
    func reloadList() {
        if let listVC = navigationController.viewControllers.first as? ListViewController {
            listVC.reloadList()
        }
    }
    
    func showDetail(presenter: DetailViewPresentable) {
        let vc = DetailViewController.instantiate()
        vc.presenter = presenter
        navigationController.pushViewController(vc, animated: true)
    }
    
}