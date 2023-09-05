import UIKit
import AVFoundation

class PreviewView: UIView {

    private let previewLayer: AVCaptureVideoPreviewLayer
    
    init(previewLayer: AVCaptureVideoPreviewLayer) {
        self.previewLayer = previewLayer
        super.init(frame: CGRect.zero)
        layer.addSublayer(previewLayer)
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
}
