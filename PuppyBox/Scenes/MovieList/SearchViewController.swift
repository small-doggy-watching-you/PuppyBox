//
//  SearchViewController.swift
//  PuppyBox
//
//  Created by 노가현 on 7/16/25.
//

import Kingfisher
import SnapKit
import Then
import UIKit

class SearchViewController: UIViewController {
    private let viewModel = MovieListViewModel()

    private var movies: [MovieResults] {
        return viewModel.state.nowPlaying + viewModel.state.upcoming
    }

    private var searchResults: [MovieResults] = []

    private var isFiltering: Bool {
        return !(searchBar.text?.isEmpty ?? true)
    }

    private let searchBar = UISearchBar().then {
        $0.placeholder = "검색어를 입력하세요"
        $0.searchBarStyle = .minimal
        $0.showsCancelButton = false
        $0.returnKeyType = .search
        $0.searchTextField.clearButtonMode = .whileEditing
    }

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).then {
        $0.backgroundColor = .white
        $0.register(MoviePosterCell.self, forCellWithReuseIdentifier: MoviePosterCell.identifier)
        $0.dataSource = self
        $0.delegate = self
        $0.keyboardDismissMode = .onDrag
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
        view.backgroundColor = .white
        setupLayout()
        setupCollectionViewLayout()
        searchBar.delegate = self

        viewModel.onDataUpdated = { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        collectionView.delegate = self
        viewModel.fetchAllData()
    }

    @objc private func handlePosterButtonTap(_ sender: UIButton) {
        let idx = sender.tag
        let movie = isFiltering ? searchResults[idx] : movies[idx]
        let detailVC = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detailVC, animated: true)
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

    private func makeLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 3),
            heightDimension: .absolute(152)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(152)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item, item]
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func setupCollectionViewLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isFiltering ? searchResults.count : movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviePosterCell.identifier,
            for: indexPath
        ) as! MoviePosterCell

        let movie = isFiltering
            ? searchResults[indexPath.item]
            : movies[indexPath.item]

        cell.setImage(with: movie.posterPath)
        cell.setNumber(nil)

        cell.posterButton.tag = indexPath.item
        cell.posterButton.addTarget(self, action: #selector(handlePosterButtonTap(_:)), for: .touchUpInside)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = isFiltering
            ? searchResults[indexPath.item]
            : movies[indexPath.item]
        let detailVC = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = []
        } else {
            // 제목에 검색어 포함된 영화만 필터링
            searchResults = movies.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
        collectionView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchResults = []
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
}

@available(iOS 17.0, *)
#Preview {
    SearchViewController()
}
