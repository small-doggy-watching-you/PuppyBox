//
//  MovieListViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/15/25.
//

import Kingfisher
import SnapKit
import Then
import UIKit

// MARK: - MovieListViewController

class MovieListViewController: UIViewController {
    // MARK: - Properties

    private let viewModel = MovieListViewModel()
    private let sectionTitles = ["무비차트", "현재 상영작", "상영 예정작"]

    private let labelImageView = UIImageView().then {
        $0.image = UIImage(named: "PuppyBoxLabel")
        $0.contentMode = .scaleAspectFit
    }

    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "PuppyBoxLogo")
        $0.contentMode = .scaleAspectFit
    }

    private lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    )

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backButtonDisplayMode = .minimal
        view.backgroundColor = .white
        setupHeader()
        setupCollectionView()

        viewModel.onDataUpdated = { [weak self] _ in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.fetchAllData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - UI Setup

    private func setupHeader() {
        view.addSubview(labelImageView)
        view.addSubview(logoImageView)

        labelImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(32)
        }

        logoImageView.snp.makeConstraints { make in
            make.centerY.equalTo(labelImageView)
            make.leading.equalTo(labelImageView.snp.trailing).offset(10)
            make.width.height.equalTo(40)
        }
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(
            MoviePosterCell.self,
            forCellWithReuseIdentifier: MoviePosterCell.identifier
        )
        collectionView.register(
            MovieSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MovieSectionHeader.identifier
        )

        collectionView.snp.makeConstraints {
            $0.top.equalTo(labelImageView.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Layout

    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(138),
                heightDimension: .absolute(197)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(400),
                heightDimension: .absolute(197)
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: Array(repeating: item, count: 3)
            )
            group.interItemSpacing = .fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.interGroupSpacing = 10
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 16, leading: 20, bottom: 20, trailing: 20
            )

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(30)
            )
            let boundaryItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            section.boundarySupplementaryItems = [boundaryItem]
            return section
        }
    }

    // MARK: - Actions

    @objc private func handlePosterButtonTap(_ sender: UIButton) {
        guard let sectionString = sender.accessibilityIdentifier,
              let section = Int(sectionString) else { return }
        let row = sender.tag

        let movie: MovieResults?
        switch section {
        case 0: movie = viewModel.state.movieChart[row]
        case 1:
            let reversedIndex = viewModel.state.nowPlaying.count - 1 - row
            movie = viewModel.state.nowPlaying[reversedIndex]
        case 2: movie = viewModel.state.upcoming[row]
        default: movie = nil
        }

        if let movie = movie {
            let detailVC = MovieDetailViewController(movie: movie)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionTitles.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return viewModel.state.movieChart.count
        case 1: return viewModel.state.nowPlaying.count
        case 2: return viewModel.state.upcoming.count
        default: return 0
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MoviePosterCell.identifier,
            for: indexPath
        ) as! MoviePosterCell

        let movie: MovieResults?
        switch indexPath.section {
        case 0: movie = viewModel.state.movieChart[indexPath.item]
        case 1:
            let reversedIndex = viewModel.state.nowPlaying.count - 1 - indexPath.item
            movie = viewModel.state.nowPlaying[reversedIndex]
        case 2: movie = viewModel.state.upcoming[indexPath.item]
        default: movie = nil
        }
        cell.setImage(with: movie?.posterPath)

        cell.posterButton.tag = indexPath.item
        cell.posterButton.accessibilityIdentifier = "\(indexPath.section)"
        cell.posterButton.addTarget(
            self,
            action: #selector(handlePosterButtonTap(_:)),
            for: .touchUpInside
        )

        if indexPath.section == 0 {
            cell.setNumber(indexPath.item + 1)
        } else {
            cell.setNumber(nil)
        }
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: MovieSectionHeader.identifier,
            for: indexPath
        ) as! MovieSectionHeader
        header.setTitle(sectionTitles[indexPath.section])
        return header
    }
}

@available(iOS 17.0, *)
#Preview {
    MovieListViewController()
}
