//
//  MovieListViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/15/25.
//

import SnapKit
import Then
import UIKit

class MovieListViewController: UIViewController {
    private let labelImageView = UIImageView().then {
        $0.image = UIImage(named: "PuppyBoxLabel")
        $0.contentMode = .scaleAspectFit
    }

    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "PuppyBoxLogo")
        $0.contentMode = .scaleAspectFit
    }

    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())

    private let sectionTitles = ["무비차트", "현재 상영작", "상영 예정작"]

    private let dummyData = [
        (0..<10).map { "무비차트 영화\($0)" },
        (0..<5).map { "현재상영 영화\($0)" },
        (0..<8).map { "상영예정 영화\($0)" }
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeader()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

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
        collectionView.register(MoviePosterCell.self, forCellWithReuseIdentifier: MoviePosterCell.identifier)
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
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 20, trailing: 20)

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
}

extension MovieListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sectionTitles.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dummyData[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviePosterCell.identifier, for: indexPath) as! MoviePosterCell
        let movieTitle = dummyData[indexPath.section][indexPath.item]
        cell.setTitle(movieTitle)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MovieSectionHeader.identifier, for: indexPath) as! MovieSectionHeader
        header.setTitle(sectionTitles[indexPath.section])
        return header
    }
}

@available(iOS 17.0, *)
#Preview {
    MovieListViewController() // 자기가 볼 뷰컨트롤러로
}
