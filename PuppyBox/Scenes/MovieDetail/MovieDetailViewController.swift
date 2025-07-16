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

import SwiftUI // 프리뷰용
import UIKit

class MovieDetailViewController: UIViewController {
    private let movieDetailView = MovieDetailView()
    private let movieDetailViewModel = MovieDetailViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
    }

    private func bindViewModel() {
        movieDetailViewModel.onStateChanged = { [weak self] state in
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

// SwiftUI Preview용 래퍼
struct MovieDetailViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return MovieDetailViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // 필요시 업데이트
    }
}

// #Preview로 보기
#Preview {
    MovieDetailViewControllerPreview()
}
