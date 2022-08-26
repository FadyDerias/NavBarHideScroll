//
//  SceneDelegate.swift
//  NavBarHideScroll
//
//  Created by Fady on 17/08/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
//        window?.rootViewController = ScrollingViewController(navigationTitle: "Scroll 1")
        window?.rootViewController = CustomNavigationController(rootViewController: ScrollingViewController())
        window?.makeKeyAndVisible()
    }
}

