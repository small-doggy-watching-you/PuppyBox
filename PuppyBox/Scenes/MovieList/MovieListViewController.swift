//
//  MovieListViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/15/25.
//

import UIKit
import SwiftUI

// MARK: - ViewController
class MovieListViewController: UIViewController {
    let movieListViewModel = MovieListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupHeader()

        movieListViewModel.onDataUpdated = { [weak self] result in
            guard let self else { return }
            print(result)
        }

        movieListViewModel.action(.fetchData)
    }

    private func setupHeader() {
        let labelImageView = UIImageView()
        labelImageView.image = UIImage(named: "PuppyBoxLabel")
        labelImageView.contentMode = .scaleAspectFit
        view.addSubview(labelImageView)

        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "PuppyBoxLogo")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)

        labelImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            labelImageView.widthAnchor.constraint(equalToConstant: 129),
            labelImageView.heightAnchor.constraint(equalToConstant: 40),

            logoImageView.leadingAnchor.constraint(equalTo: labelImageView.trailingAnchor, constant: 10),
            logoImageView.centerYAnchor.constraint(equalTo: labelImageView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 40),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

// MARK: - SwiftUI Preview Support
struct MovieListViewControllerPreview: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MovieListViewController {
        return MovieListViewController()
    }

    func updateUIViewController(_ uiViewController: MovieListViewController, context: Context) {}
}

#Preview {
    MovieListViewControllerPreview()
}
