//
//  TabBarController.swift
//  Macetohuerto
//
//  Created by Lopez Centelles, Josep on 22/06/2018.
//  Copyright © 2018 Josep. All rights reserved.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        let downloadViewController = ViewController()
        downloadViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        let bookmarkViewController = ChatViewController()
        bookmarkViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
       
        let viewControllerList = [ downloadViewController, bookmarkViewController ]
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
    }
}
