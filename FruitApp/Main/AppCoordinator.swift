//
//  AppCoordinator.swift
//  FruitApp
//
//  Created by Alina Ene on 17/11/2019.
//  Copyright © 2019 Alina Ene. All rights reserved.
//

import UIKit

class Coordinator: NSObject {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {}
}

extension AppCoordinator: CrashEyeDelegate {
    func crashEyeDidCatchCrash(with model: CrashModel) {
        queryManager.sendStat(event: .error, data: "error") { (isSuccessful: Bool, error: String?) in
            print("\(#function) app crash \(model.reason ?? "unknown reason")")
        }
    }
}

class AppCoordinator: Coordinator {
    
    private let queryManager = QueryManager()
    
    override init(navigationController: UINavigationController) {
        super.init(navigationController: navigationController)
        self.navigationController.delegate = self
        CrashEye.add(delegate: self)
    }
    
    deinit {
        CrashEye.remove(delegate: self)
    }
    
    override func start() {
        super.start()
        let vc = ListViewController.instantiate()
        vc.presenter = ListViewPresenter(coordinator: self, queryManager: queryManager)
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

extension AppCoordinator: UINavigationControllerDelegate {
   
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        print(#function)
        //queryManager.startDisplayStat()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        print(#function)
//        queryManager.endDisplayStat()
    }
    
}
