//
//  ViewController1.swift
//  TinyRouter
//
//  Created by liulishuo on 2021/8/20.
//

import UIKit

struct User {
    let name: String
    let age: Int
}

class ViewController1: UIViewController {

    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        print("received: \(user)")
    }
}
