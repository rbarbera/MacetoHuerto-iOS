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
        let plannerTabBarItem: UITabBarItem = UITabBarItem(title: "planificador".localized, image: UIImage(named: "planner")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "planner"))
        planner.tabBarItem = plannerTabBarItem
        let chat = ChatViewController()
        let chatTabBarItem: UITabBarItem = UITabBarItem(title: "doubts_chat".localized, image: UIImage(named: "chat")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), selectedImage: UIImage(named: "chat"))

        chat.tabBarItem = chatTabBarItem
        let viewControllerList = [ planner, chat ]
        viewControllers = viewControllerList.map { UINavigationController(rootViewController: $0) }
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
