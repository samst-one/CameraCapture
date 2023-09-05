import Foundation

class StartCameraUseCase {
    
    private let session: CameraSesion
    
    init(session: CameraSesion) {
        self.session = session
    }
    
    func start(completion: @MainActor @escaping () -> ()) {
        session.start(completion: completion)
    }
}
