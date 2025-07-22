//
//  TicketViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/19/25.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class TicketViewController: UIViewController {
    private let viewModel: TicketViewModel
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!

    init(viewModel: TicketViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "예매 확인"
        setupNavigationBar()
        setupUI()
        applySnapshot()
    }

    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.backButtonDisplayMode = .minimal
        navigationController?.navigationBar.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "house.fill"),
            style: .plain,
            target: self,
            action: #selector(goHome)
        )
    }

    @objc private func goHome() {
        navigationController?.popToRootViewController(animated: true)
    }

    private func setupUI() {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }

        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }

        let posterImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 20
            if let path = viewModel.state.movie.posterPath {
                let urlStr = ImagePathService.makeImagePath(size: .w780, posterPath: path)
                if let url = URL(string: urlStr) {
                    $0.kf.setImage(with: url)
                }
            }
        }
        contentView.addSubview(posterImageView)
        posterImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(posterImageView.snp.width).dividedBy(1.7)
        }

        let infoView = MovieInfoView()
        infoView.configure(with: viewModel.state.movie)
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
        }

        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(140))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(140))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = 16
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            return section
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(infoView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(130)
        }

        dataSource = UICollectionViewDiffableDataSource<Int, String>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatInfoCell", for: indexPath) as! SeatInfoCell
            let row = String(itemIdentifier.prefix(1))
            let number = String(itemIdentifier.suffix(itemIdentifier.count - 1))
            cell.configure(salon: "1관\n(3층)", row: row, num: number)
            return cell
        }
        collectionView.register(SeatInfoCell.self, forCellWithReuseIdentifier: "SeatInfoCell")

        let bottomInfoView = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.alignment = .center
        }

        func makeColumn(top: String, bottom: String) -> UIStackView {
            let topLabel = UILabel().then {
                $0.text = top
                $0.font = .systemFont(ofSize: 12, weight: .medium)
                $0.textColor = .systemGray
                $0.textAlignment = .center
            }
            let bottomLabel = UILabel().then {
                $0.text = bottom
                $0.font = .systemFont(ofSize: 16, weight: .bold)
                $0.textColor = .white
                $0.textAlignment = .center
            }
            let stack = UIStackView(arrangedSubviews: [topLabel, bottomLabel])
            stack.axis = .vertical
            stack.spacing = 4
            stack.alignment = .center
            return stack
        }

        bottomInfoView.addArrangedSubview(makeColumn(top: "날짜", bottom: viewModel.state.dateString))
        bottomInfoView.addArrangedSubview(makeColumn(top: "시간", bottom: viewModel.state.timeString))
        bottomInfoView.addArrangedSubview(makeColumn(top: "가격", bottom: viewModel.state.priceString))
        contentView.addSubview(bottomInfoView)
        bottomInfoView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        let goMyPageButton = UIButton(type: .system).then {
            $0.setTitle("마이페이지로", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .appPrimary
            $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(goToMyPage), for: .touchUpInside)
        }
        contentView.addSubview(goMyPageButton)
        goMyPageButton.snp.makeConstraints {
            $0.top.equalTo(bottomInfoView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-40)
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.state.seats, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    @objc private func goToMyPage() {
        tabBarController?.selectedIndex = 2
    }
}
