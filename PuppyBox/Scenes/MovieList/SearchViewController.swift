//
//  SearchViewController.swift
//  PuppyBox
//
//  Created by 노가현 on 7/16/25.
//

import SnapKit
import Then
import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    private let searchBar = UISearchBar().then {
        $0.placeholder = "검색어를 입력하세요"
        $0.searchBarStyle = .minimal
        $0.showsCancelButton = false
        $0.returnKeyType = .search
        $0.searchTextField.clearButtonMode = .whileEditing
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        searchBar.delegate = self
    }

    private func setupLayout() {
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(36)
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("현재 검색어 :", searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}

@available(iOS 17.0, *)
#Preview {
    SearchViewController() // 자기가 볼 뷰컨트롤러로
}
