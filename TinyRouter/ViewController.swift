//
//  ViewController.swift
//  TinyRouter
//
//  Created by liulishuo on 2021/8/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onClickPush(_ sender: Any) {
        TinyRouter.push(.x1, context: User(name: "name", age: 12))
    }

    @IBAction func onClickPresent(_ sender: Any) {
        TinyRouter.present(RouteKey.x1.rawValue + "?page=10&index=20", context: User(name: "name", age: 12), wrap: UINavigationController.self)
    }

    @IBAction func onClickHandle(_ sender: Any) {
        TinyRouter.handle(.x2, context: nil)
    }

}

