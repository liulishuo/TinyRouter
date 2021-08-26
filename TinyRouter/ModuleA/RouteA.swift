//
//  RouteA.swift
//  TinyRouter
//
//  Created by liulishuo on 2021/8/20.
//

import UIKit

extension RouteKey {
    static let x1 = RouteKey(rawValue: "abc://123.com/x1")
    static let x2 = RouteKey(rawValue: "abc://123.com/x2")
}

class RouteA: ModuleRoute {
    static func register(by router: TinyRouter.Type) {

        router.register(viewControllerKey: RouteKey.x1.rawValue) { _, query, context in
            let viewController = ViewController1()
            viewController.title = "\(query)"
            viewController.user = context as? User
            return viewController
        }

        router.register(handlerKey: RouteKey.x2.rawValue) { _, _, _ in
            guard let currentViewController = UIViewController.topMost else {
                return false
            }
            let ac = UIAlertController(title: "x2", message: "x2", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
            currentViewController.present(ac, animated: true, completion: nil)
            return true
        }
    }
}
