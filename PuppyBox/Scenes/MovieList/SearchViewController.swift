//
//  SearchViewController.swift
//  PuppyBox
//
//  Created by 노가현 on 7/16/25.
//

import SnapKit
import Then
import UIKit

class SearchViewController: UIViewController {
    private let searchBar = UISearchBar().then {
        $0.placeholder = "검색어를 입력하세요"
        $0.searchBarStyle = .minimal
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }

    private func setupLayout() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(36)
        }
    }
}
