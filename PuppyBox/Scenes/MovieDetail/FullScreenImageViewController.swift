//
//  FullScreenImageViewController.swift
//  PuppyBox
//
//  Created by 김우성 on 7/17/25.
//

import SnapKit
import Then
import UIKit

final class FullScreenImageViewController: UIViewController, UIScrollViewDelegate {
    private let image: UIImage
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bouncesZoom = true
        $0.minimumZoomScale = 1.0 // 실제 초기값은 viewDidLayoutSubviews에서 조정
        $0.maximumZoomScale = 2.0
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = true
    }
    
    private let closeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.tintColor = .white
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupActions()
        setupDoubleTapGesture()
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        [scrollView, closeButton].forEach {
            view.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        scrollView.delegate = self
        
        scrollView.addSubview(imageView)
        imageView.image = image
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(32)
        }
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    private func setupDoubleTapGesture() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapScrollView(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
    }
    
    @objc private func didDoubleTapScrollView(_ gesture: UITapGestureRecognizer) {
        let pointInView = gesture.location(in: imageView)
        
        // 확대 상태가 아니라면 -> 최대치로 확대
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            let newZoomScale = scrollView.maximumZoomScale
            let width = scrollView.bounds.size.width / newZoomScale
            let height = scrollView.bounds.size.height / newZoomScale
            let zoomRect = CGRect(
                x: pointInView.x - (width / 2.0),
                y: pointInView.y - (height / 2.0),
                width: width,
                height: height
            )
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            // 이미 확대 상태라면 -> 최소로 되돌리기
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    // 스크롤뷰가 레이아웃을 가진 뒤에 이미지 크기에 맞춰 zoomScale을 조정
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let image = imageView.image else { return }
        
        imageView.frame = CGRect(origin: .zero, size: image.size)
        scrollView.contentSize = image.size
        
        setZoomScaleForFit()
        centerImage()
    }
    
    private func setZoomScaleForFit() {
        guard let image = imageView.image else { return }
        
        let scrollViewSize = scrollView.bounds.size
        let imageSize = image.size
        
        // 가로 세로 비율을 비교하여 fit에 맞는 scale 계산
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
    
    private func centerImage() {
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        
        let horizontalInset = max(0, (scrollViewSize.width - imageViewSize.width) / 2)
        let verticalInset = max(0, (scrollViewSize.height - imageViewSize.height) / 2)
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
    }
    
    // 확대 축소할 대상
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        centerImage() // 확대 축소 후에도 이미지가 중앙에 위치하도록
    }
}
