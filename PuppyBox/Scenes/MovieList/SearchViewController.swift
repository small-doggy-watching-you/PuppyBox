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

// MARK: - SearchViewController

class SearchViewController: UIViewController {
    // MARK: - Properties
    
    private let viewModel = MovieListViewModel()
    
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
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ""
        navigationItem.backButtonDisplayMode = .minimal // 뒤로가기 버튼 텍스트 제거
        view.backgroundColor = .white
        setupLayout()
        setupCollectionViewLayout()
        searchBar.delegate = self
        
        viewModel.onDataUpdated = { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.fetchAllData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 다시 네비게이션 바 보이기
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: - Layout
    
    // 서치바, 컬렉션뷰의 레이아웃 설정
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
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    // 포스터 버튼 탭 시 상세 화면으로 이동
    @objc private func handlePosterButtonTap(_ sender: UIButton) {
        let idx = sender.tag
        let movie = viewModel.state.searchResults[idx]
        let detailVC = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.state.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviePosterCell.identifier,
            for: indexPath
        ) as! MoviePosterCell
        
        let movie = viewModel.state.searchResults[indexPath.item]
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
        let movie = viewModel.state.searchResults[indexPath.item]
        let detailVC = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.updateSearch(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        viewModel.updateSearch("")
        searchBar.resignFirstResponder()
    }
}

@available(iOS 17.0, *)
#Preview {
    SearchViewController()
}
