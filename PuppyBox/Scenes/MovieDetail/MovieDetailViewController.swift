//
//  MovieDetailViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/16/25.
//

import UIKit

class MovieDetailViewController: UIViewController {
    private let movieDetailView = MovieDetailView()
    private let viewModel: MovieDetailViewModel

    init(movie: MovieResults) {
        self.viewModel = MovieDetailViewModel(movie: movie)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
    }

    private func setupView() {
        view.addSubview(movieDetailView)
        movieDetailView.frame = view.bounds

        navBarSetting()
    }

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            guard let movie = state.movie else { return }
            DispatchQueue.main.async {
                self?.movieDetailView.configure(with: movie)
            }
        }
    }

    func configure(with movie: MovieResults) {
        viewModel.action(.configure(movie))
    }

    private func navBarSetting() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

//// #Preview로 보기
// @available(iOS 17.0, *)
// #Preview {
//    MovieDetailViewController()
// }
