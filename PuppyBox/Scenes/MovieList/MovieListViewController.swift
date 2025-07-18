//
//  MovieListViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/15/25.
//

import UIKit

class MovieListViewController: UIViewController {
    let movieListViewModel = MovieListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemOrange

        // 뷰모델의 데이터 업데이트 콜백 설정
        // 데이터가 업데이트되면 호출
        movieListViewModel.onDataUpdated = { [weak self] result in
            guard let self else { return }

            print(result)
        }

        // 데이터 요청 액션 실행
        movieListViewModel.action(.fetchData)
    }
}
