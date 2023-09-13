import UIKit
import AVFoundation

class PreviewView: UIView {
    
    private let previewLayer: AVCaptureVideoPreviewLayer
    private let presenter: Presenter
    private var pinchRecognizer: UIPinchGestureRecognizer!
    private var tapRecognizer: UITapGestureRecognizer!
    
    init(previewLayer: AVCaptureVideoPreviewLayer,
         presenter: Presenter) {
        self.previewLayer = previewLayer
        self.presenter = presenter
        
        super.init(frame: CGRect.zero)
        layer.addSublayer(previewLayer)
        layer.addSublayer(focusBoxLayer)
        
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action:#selector(pinch(_:)))
        self.addGestureRecognizer(pinchRecognizer)
        
        tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(cameraViewTapped(_:)))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupOrientation() {
        guard let statusBarOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
            return
        }
        let videoOrientation: AVCaptureVideoOrientation = videoOrientation(viewOrientation: statusBarOrientation) ?? .portrait
            
        previewLayer.frame = layer.bounds
        previewLayer.connection?.videoOrientation = videoOrientation
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupOrientation()
    }
    
    private func videoOrientation(viewOrientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation? {
        switch viewOrientation {
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeRight: return .landscapeRight
        case .landscapeLeft: return .landscapeLeft
        case .portrait: return .portrait
        default: return nil
        }
    }
    
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .changed {
            presenter.didZoomTo(sender.scale)
            pinchRecognizer.scale = 1
        }
    }
    
    @objc private func cameraViewTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: self)
        showBox(at: location)
        //        addFocusIndicatorView(at: location) // If you want to indicate it in the UI
        
        let captureDeviceLocation = previewLayer.captureDevicePointConverted(fromLayerPoint: location)
        
        presenter.didFocus(at: captureDeviceLocation)
    }
    
    func showBox(at point: CGPoint) {
        focusBoxLayer.removeAllAnimations()
        let scaleKey = "zoom in focus box"
        let fadeInKey = "fade in focus box"
        let pulseKey = "pulse focus box"
        let fadeOutKey = "fade out focus box"
        guard focusBoxLayer.animation(forKey: scaleKey) == nil,
              focusBoxLayer.animation(forKey: fadeInKey) == nil,
              focusBoxLayer.animation(forKey: pulseKey) == nil,
              focusBoxLayer.animation(forKey: fadeOutKey) == nil
        else { return }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        focusBoxLayer.position = point
        CATransaction.commit()
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 1
        scale.toValue = 0.375
        scale.duration = 0.3
        scale.isRemovedOnCompletion = false
        scale.fillMode = .forwards
        
        let opacityFadeIn = CABasicAnimation(keyPath: "opacity")
        opacityFadeIn.fromValue = 0
        opacityFadeIn.toValue = 1
        opacityFadeIn.duration = 0.3
        opacityFadeIn.isRemovedOnCompletion = false
        opacityFadeIn.fillMode = .forwards
        
        let pulsing = CABasicAnimation(keyPath: "borderColor")
        pulsing.toValue = UIColor(red: 248/255, green: 216/255, blue: 74/255, alpha: 0.5).cgColor

        pulsing.repeatCount = 2
        pulsing.duration = 0.2
        pulsing.beginTime = CACurrentMediaTime() + 0.3 // wait for the fade in to occur
        
        let opacityFadeOut = CABasicAnimation(keyPath: "opacity")
        opacityFadeOut.fromValue = 1
        opacityFadeOut.toValue = 0
        opacityFadeOut.duration = 0.5
        opacityFadeOut.beginTime = CACurrentMediaTime() + 1 // seconds
        opacityFadeOut.isRemovedOnCompletion = false
        opacityFadeOut.fillMode = .forwards
        
        focusBoxLayer.add(scale, forKey: scaleKey)
        focusBoxLayer.add(opacityFadeIn, forKey: fadeInKey)
        focusBoxLayer.add(pulsing, forKey: pulseKey)
        focusBoxLayer.add(opacityFadeOut, forKey: fadeOutKey)
    }
    
    // MARK: - Private Properties
    
    private lazy var focusBoxLayer: CALayer = {
        let box = CALayer()
        box.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        box.borderWidth = 4
        box.borderColor = UIColor(red: 248/255, green: 216/255, blue: 74/255, alpha: 1).cgColor
        box.opacity = 0
        return box
    }()
}

extension PreviewView: Viewable {
    func didSetCamera() {
        setupOrientation()
    }
}

protocol Viewable {
    func didSetCamera()
}
