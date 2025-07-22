//
//  SplashViewController.swift
//  PuppyBox
//
//  Created by 노가현 on 7/21/25.
//

import AVFoundation
import SnapKit
import UIKit

class SplashViewController: UIViewController {
    // MARK: – Properties

    private let videoContainer = UIView()
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 12
        return sv
    }()

    private let labelImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "PuppyBoxLabel")
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!

    // MARK: – Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playSplashVideo()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = videoContainer.bounds
    }

    // MARK: – Setup

    private func setupViews() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-35)
        }

        stackView.addArrangedSubview(videoContainer)
        stackView.addArrangedSubview(labelImageView)

        videoContainer.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width).multipliedBy(0.4)
            make.height.equalTo(videoContainer.snp.width)
        }
        labelImageView.snp.makeConstraints { make in
            make.width.equalTo(videoContainer.snp.width).multipliedBy(0.6)
            make.height.equalTo(labelImageView.snp.width).multipliedBy(0.3)
        }
    }

    // MARK: – Video Playback#imageLiteral(resourceName: "simulator_screenshot_8300C169-7CBB-47E9-A559-64F19001B77F.png")

    private func playSplashVideo() {
        guard let url = Bundle.main.url(forResource: "PuppyBoxOpen", withExtension: "mp4") else {
            transitionToLogin()
            return
        }

        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill

        videoContainer.layoutIfNeeded()
        playerLayer.frame = videoContainer.bounds
        videoContainer.layer.insertSublayer(playerLayer, at: 0)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(videoDidEnd),
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )

        player.play()
    }

    @objc private func videoDidEnd() {
        NotificationCenter.default.removeObserver(
            self,
            name: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem
        )
        DispatchQueue.main.async {
            self.transitionToLogin()
        }
    }

    // MARK: – Transition to Login

    private func transitionToLogin() {
        // instantiate LoginVC from Main.storyboard
        let loginVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "LoginVC")

        // wrap in a UINavigationController so push/pop works
        let nav = UINavigationController(rootViewController: loginVC)

        // swap rootViewController
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController = nav
            keyWindow.makeKeyAndVisible()
            UIView.transition(
                with: keyWindow,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
        } else {
            // fallback: present modally
            present(nav, animated: true, completion: nil)
        }
    }
}
