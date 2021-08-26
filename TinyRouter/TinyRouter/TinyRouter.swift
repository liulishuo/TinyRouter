//
//  TinyRouter.swift
//  TinyRouter
//
//  Created by liulishuo on 2021/8/20.
//

import Foundation
import UIKit

public struct RouteKey {
    let rawValue: String
}

public protocol ModuleRoute {
    static func register(by router: TinyRouter.Type)
}

public typealias ViewControllerFactory = (_ key: String, _ query: [String: String]? , _ context: Any?) -> UIViewController?
public typealias URLOpenHandlerFactory = (_ key: String, _ query: [String: String]? , _ context: Any?) -> Bool
public typealias URLOpenHandler = () -> Bool

public final class TinyRouter {

    private static var viewControllerFactories = [String: ViewControllerFactory]()
    private static var handlerFactories = [String: URLOpenHandlerFactory]()


    /// 注册每个模块的路由
    /// - Parameter routes: 模块路由数组
    public class func registerModuleRoute(routes: [ModuleRoute.Type]) {
        for route in routes {
            route.register(by: self)
        }
    }

    /// 注册viewController的初始化闭包
    /// - Parameters:
    ///   - viewControllerKey: key
    ///   - factory: viewController的初始化闭包
    public class func register(viewControllerKey: String, _ factory: @escaping ViewControllerFactory) {
        self.viewControllerFactories[viewControllerKey] = factory
    }

    /// 注册一个闭包
    /// - Parameters:
    ///   - handlerKey: key
    ///   - factory: 闭包
    public class func register(handlerKey: String, _ factory: @escaping URLOpenHandlerFactory) {
        self.handlerFactories[handlerKey] = factory
    }


    /// 通过url获取目标viewController
    /// - Parameters:
    ///   - url: url
    ///   - context: 参数
    /// - Returns: 目标viewController
    public class func viewController(url: String, context: Any?) -> UIViewController? {
        guard let key = url.key else {
            return nil
        }
        return viewController(for: key, query: url.query, context: context)
    }

    /// 通过key获取目标viewController
    /// - Parameters:
    ///   - key: 如果是url转换的key，此参数等价于 URL的 scheme + host + path
    ///   - query: URL的query部分
    ///   - context: 参数
    /// - Returns: 目标viewController
    private class func viewController(for key: String,
                                      query: [String: String]?,
                                      context: Any?) -> UIViewController? {
        guard let factory = viewControllerFactories[key] else {
            return nil
        }
        return factory(key, query, context)
    }

    /// 找到key对应的闭包
    /// - Parameters:
    ///   - key: 如果是url转换的key，此参数等价于 URL的 scheme + host + path
    ///   - query: URL的query部分
    ///   - context: 参数
    /// - Returns: 闭包
    private class func handler(for key: String,
                               query: [String: String]?,
                               context: Any?) -> URLOpenHandler? {
        guard let factory = handlerFactories[key] else {
            return nil
        }
        return { factory(key, query, context) }
    }
}

//MARK: push
extension TinyRouter {

    /// push 目标viewController
    /// - Parameters:
    ///   - routeKey: 路由
    ///   - context: 参数
    ///   - from: 当前viewController
    ///   - animated: 是否使用转场动画
    /// - Returns: 目标viewController
    @discardableResult
    public class func push(_ routeKey: RouteKey,
                           context: Any? = nil,
                           from: UINavigationController? = nil,
                           animated: Bool = true) -> UIViewController? {
        self.push(routeKey.rawValue, context: context, from: from, animated: animated)
    }

    /// push 目标viewController
    /// - Parameters:
    ///   - url: url
    ///   - context: 参数
    ///   - from: 当前viewController
    ///   - animated: 是否使用转场动画
    /// - Returns: 目标viewController
    @discardableResult
    public class func push(_ url: String,
                           context: Any? = nil,
                           from: UINavigationController? = nil,
                           animated: Bool = true) -> UIViewController? {
        guard let viewController = self.viewController(url: url, context: context) else {
            return nil
        }
        return self.pushViewController(viewController, from: from, animated: animated)
    }


    /// push 目标viewController
    /// - Parameters:
    ///   - viewController: 目标viewController
    ///   - from: 当前viewController
    ///   - animated: 是否使用转场动画
    /// - Returns: 目标viewController
    @discardableResult
    public class func pushViewController(_ viewController: UIViewController,
                                         from: UINavigationController?,
                                         animated: Bool) -> UIViewController? {
        guard (viewController is UINavigationController) == false else { return nil }
        guard let navigationController = from ?? UIViewController.topMost?.navigationController else { return nil }
        navigationController.pushViewController(viewController, animated: animated)
        return viewController
    }
}

//MARK: present
extension TinyRouter {


    /// present 目标viewController
    /// - Parameters:
    ///   - routeKey: 路由
    ///   - context: 参数
    ///   - wrap: 使用UINavigationController包裹 目标viewController
    ///   - from: 当前viewController
    ///   - animated: 是否使用转场动画
    ///   - completion: present完成后的回调
    /// - Returns: 目标viewController
    @discardableResult
    public class func present(_ routeKey: RouteKey,
                              context: Any? = nil,
                              wrap: UINavigationController.Type? = nil,
                              from: UIViewController? = nil,
                              animated: Bool = true,
                              completion: (() -> Void)? = nil) -> UIViewController? {
        self.present(routeKey.rawValue,
                     context: context,
                     wrap: wrap,
                     from: from,
                     animated: animated,
                     completion: completion)
    }

    /// present 目标viewController
    /// - Parameters:
    ///   - url: url
    ///   - context: 参数
    ///   - wrap: 使用UINavigationController包裹 目标viewController
    ///   - from: 当前viewController
    ///   - animated: 是否使用转场动画
    ///   - completion: present完成后的回调
    /// - Returns: 目标viewController
    @discardableResult
    public class func present(_ url: String,
                              context: Any? = nil,
                              wrap: UINavigationController.Type? = nil,
                              from: UIViewController? = nil,
                              animated: Bool = true,
                              completion: (() -> Void)? = nil) -> UIViewController? {
        guard let viewController = self.viewController(url: url, context: context) else {
            return nil
        }
        return self.presentViewController(viewController,
                                          wrap: wrap,
                                          from: from,
                                          animated: animated,
                                          completion: completion)
    }


    /// present 目标viewController
    /// - Parameters:
    ///   - viewController: 目标viewController
    ///   - wrap: 使用UINavigationController包裹 目标viewController
    ///   - from: 当前viewController
    ///   - animated: 是否使用转场动画
    ///   - completion: present完成后的回调
    /// - Returns: 目标viewController
    @discardableResult
    public class func presentViewController(_ viewController: UIViewController,
                                            wrap: UINavigationController.Type?,
                                            from: UIViewController?,
                                            animated: Bool,
                                            completion: (() -> Void)?) -> UIViewController? {
        guard let fromViewController = from ?? UIViewController.topMost else {
            return nil
        }

        let viewControllerToPresent: UIViewController
        if let navigationControllerClass = wrap, (viewController is UINavigationController) == false {
            viewControllerToPresent = navigationControllerClass.init(rootViewController: viewController)
        } else {
            viewControllerToPresent = viewController
        }

        fromViewController.present(viewControllerToPresent, animated: animated, completion: completion)
        return viewController
    }
}

//MARK: handle
extension TinyRouter {

    /// 执行RouteKey对应的闭包
    /// - Parameters:
    ///   - route: RouteKey
    ///   - context: 参数
    /// - Returns: 是否执行成功
    @discardableResult
    public class func handle(_ route: RouteKey, context: Any?) -> Bool {
        return handle(route.rawValue, context: context)
    }


    /// 执行url对应的闭包
    /// - Parameters:
    ///   - url: url
    ///   - context: 参数
    /// - Returns: 是否执行成功
    @discardableResult
    public class func handle(_ url: String, context: Any?) -> Bool {
        guard let handler = handler(url: url, context: context) else {
            return false
        }
        return handler()
    }


    /// 找到url对应的闭包
    /// - Parameters:
    ///   - url: url
    ///   - context: 参数
    /// - Returns: 闭包
    public class func handler(url: String, context: Any?) -> URLOpenHandler? {
        guard let key = url.key else {
            return nil
        }
        return handler(for: key, query: url.query, context: context)
    }
}

