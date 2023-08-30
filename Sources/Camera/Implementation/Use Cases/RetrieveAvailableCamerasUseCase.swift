import Foundation

class RetrieveAvailableCamerasUseCase {
    
    private let repo: CameraRepo
    
    init(repo: CameraRepo) {
        self.repo = repo
    }
    
    func get() -> [Device] {
        repo.getAvailableCameras()
    }
}
