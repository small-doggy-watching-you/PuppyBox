//
//  MovieDetailViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/16/25.
//

// 다른 뷰컨에서 이쪽으로 넘길 때
// let detailVC = MovieDetailViewController()
// detailVC.viewModel.action(.configure(selectedMovie))
// navigationController?.pushViewController(detailVC, animated: true)

import UIKit

class MovieDetailViewController: UIViewController {
    private let movieDetailView = MovieDetailView()
    private let viewModel = MovieDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    private func setupView() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundEffect = nil
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        view.addSubview(movieDetailView)
        movieDetailView.frame = view.bounds
    }

    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            DispatchQueue.main.async {
                self?.updateUI(with: state)
            }
        }
    }

    private func updateUI(with state: MovieDetailViewModel.State) {
        guard let movie = state.movie else { return }
        /*
         titleLabel.text = movie.title
         overviewLabel.text = movie.overview
         // 이미지

         */
    }
}


// #Preview로 보기
@available(iOS 17.0, *)
#Preview {
    MovieDetailViewController()
}
