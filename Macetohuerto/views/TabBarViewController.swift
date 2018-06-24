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
        let planner = ViewController()
        planner.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
        planner.tabBarItem.title = "Planner"
        let chat = ChatViewController()
        chat.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)
        chat.tabBarItem.title = "Doubts chat"
        let viewControllerList = [ planner, chat ]
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
