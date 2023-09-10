import UIKit
import AVFoundation

class PreviewView: UIView {

    private let previewLayer: AVCaptureVideoPreviewLayer
    private let presenter: Presenter
    private var pinchRecognizer: UIPinchGestureRecognizer!
    
    init(previewLayer: AVCaptureVideoPreviewLayer,
         presenter: Presenter) {
        self.previewLayer = previewLayer
        self.presenter = presenter
        
        super.init(frame: CGRect.zero)
        layer.addSublayer(previewLayer)
        
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action:#selector(pinch(_:)))
        self.addGestureRecognizer(pinchRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let statusBarOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
            return
        }
        let videoOrientation: AVCaptureVideoOrientation = videoOrientation(viewOrientation: statusBarOrientation) ?? .portrait

        previewLayer.frame = layer.bounds
        previewLayer.connection?.videoOrientation = videoOrientation
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
}
