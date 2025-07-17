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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeader()
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
}

@available(iOS 17.0, *)
#Preview {
    MovieListViewController() // 자기가 볼 뷰컨트롤러로
}
