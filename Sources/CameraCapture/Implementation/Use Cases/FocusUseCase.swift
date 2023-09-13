import Foundation

class FocusUseCase {
    
    private let focusController: FocusController
    
    init(focusController: FocusController) {
        self.focusController = focusController
    }
    
    func focus(at point: CGPoint) {
        try? focusController.focus(at: point)
    }
}
