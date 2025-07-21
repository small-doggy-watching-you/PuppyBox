//
//  SceneDelegate.swift
//  PuppyBox
//
//  Created by 김우성 on 7/15/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

//        let navi = UINavigationController()
//        navi.setViewControllers([MovieListViewController()], animated: false)
//        navi.setViewControllers([LoginViewController()], animated: false)
//        navi.setViewControllers( [MovieDetailViewController(movie: MovieResults(adult: false, backdropPath: "/nKyBbFSooRPTJVqjrDteD1lF733.jpg", genreIds: [28, 12, 18], id: 1011477, originalLanguage: "en", originalTitle: "Karate Kid: Legends", overview: "서로 다른 세대의 스승 미스터 한(성룡)과 다니엘 라루소(랄프 마치오)가 소년 '리'를 중심으로 힘을 합치며 펼쳐지는 무술 성장 드라마. 과거의 철학과 기술을 계승한 두 사부는 삶의 벽에 부딪힌 리에게 가라데의 진정한 의미를 전하며 함께 성장한다.", popularity: 750.3586, posterPath: "/AEgggzRr1vZCLY86MAp93li43z.jpg", releaseDate: "2025-05-08", title: "가라데 키드: 레전드", video: false, voteAverage: 7.314, voteCount: 388) )], animated: false )

//        window.rootViewController = MainTabBarController()
        // window.rootViewController = navi
        window.rootViewController = UINavigationController(rootViewController: LoginViewController())
        window.makeKeyAndVisible()
        self.window = window
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
