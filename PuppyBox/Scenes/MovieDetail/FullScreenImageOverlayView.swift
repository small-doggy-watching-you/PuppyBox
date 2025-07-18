//
//  FullScreenImageOverlayView.swift
//  PuppyBox
//
//  Created by 김우성 on 7/18/25.
//

import SnapKit
import Then
import UIKit

final class FullScreenImageOverlayView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.bouncesZoom = true
        $0.minimumZoomScale = 1.0
        $0.maximumZoomScale = 2.0
        $0.backgroundColor = .clear
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
    
    private var dismissHandler: (() -> Void)?

    init(image: UIImage, dismissHandler: @escaping () -> Void) {
        super.init(frame: .zero)
        self.dismissHandler = dismissHandler
        configureUI(image: image)
        setupGestures()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configureUI(image: UIImage) {
        backgroundColor = .black
        
        addSubview(scrollView)
        addSubview(closeButton)
        scrollView.addSubview(imageView)
        
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(32)
        }
        
        scrollView.delegate = self
        imageView.image = image
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { imageView }
    func scrollViewDidZoom(_ scrollView: UIScrollView) { centerImage() }
    
    private func setupGestures() {
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        pan.delegate = self
        addGestureRecognizer(pan)
    }
    
    @objc private func dismissSelf() {
        removeFromSuperview()
        dismissHandler?()
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        let pointInView = gesture.location(in: imageView)
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            let newZoomScale = scrollView.maximumZoomScale
            let width = scrollView.bounds.size.width / newZoomScale
            let height = scrollView.bounds.size.height / newZoomScale
            let zoomRect = CGRect(x: pointInView.x - (width / 2), y: pointInView.y - (height / 2), width: width, height: height)
            scrollView.zoom(to: zoomRect, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let progress = min(max(abs(translation.y) / bounds.height, 0), 1)
        switch gesture.state {
        case .changed:
            scrollView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            backgroundColor = UIColor.black.withAlphaComponent(1 - progress * 0.8)
        case .ended, .cancelled:
            if abs(translation.y) > 120 {
                let direction: CGFloat = translation.y > 0 ? 1 : -1
                let offscreenY = direction * (bounds.height + 200)
                UIView.animate(withDuration: 0.25, animations: {
                    self.scrollView.transform = CGAffineTransform(translationX: 0, y: offscreenY)
                    self.backgroundColor = UIColor.black.withAlphaComponent(0)
                }, completion: { _ in
                    self.removeFromSuperview()
                    self.dismissHandler?()
                })
            } else {
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.6,
                               options: [],
                               animations: {
                                   self.scrollView.transform = .identity
                                   self.backgroundColor = .black
                               })
            }
        default:
            break
        }
    }
}
