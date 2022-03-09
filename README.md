# TinyRouter
A simplified version of [URLNavigator](https://github.com/devxoul/URLNavigator)

## Usage
- push
```swift
TinyRouter.push(.x1, context: User(name: "name", age: 12))
```
- present
```swift
TinyRouter.present(RouteKey.x1.rawValue + "?page=10&index=20", context: User(name: "name", age: 12), wrap: UINavigationController.self)
```
- action
```swift
TinyRouter.handle(.x2, context: nil)
```
