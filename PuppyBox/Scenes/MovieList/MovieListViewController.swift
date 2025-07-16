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
        // Do any additional setup after loading the view.
        movieListViewModel.onDataUpdated = { [weak self] result in
            guard let self else { return }
            print(result)
        }
        movieListViewModel.action(.fetchData)
    }
}
