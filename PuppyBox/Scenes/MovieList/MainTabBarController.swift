//
//  MainTabBarController.swift
//  PuppyBox
//
//  Created by 노가현 on 7/16/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .red
        setupViewControllers()
    }

    private func setupViewControllers() {
        let homeVC = MovieListViewController()
        homeVC.title = "홈"
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        homeNav.isNavigationBarHidden = true

        let searchVC = SearchViewController()
        searchVC.title = "검색"
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchNav.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            // selectedImage: UIImage(systemName: "magnifyingglass.fill")
            selectedImage: nil
        )
        // searchNav.isNavigationBarHidden = true
//
//        let myPageVC = MyPageViewController()
//        myPageVC.title = "마이페이지"
//        let myPageNav = UINavigationController(rootViewController: myPageVC)
//        myPageNav.tabBarItem = UITabBarItem(
//            title: "마이페이지",
//            image: UIImage(systemName: "person"),
//            selectedImage: UIImage(systemName: "person.fill")
//        )

        viewControllers = [homeNav, searchNav /*, myPageNav */]
    }
}
