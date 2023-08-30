import Foundation

class CameraRepo {
    
    private let dataSource: DataSource
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    func getCamera(with id: String) -> Device? {
        return dataSource.cameras.first(where: { $0.id == id })
    }
    
    func getAvailableCameras() -> [Device] {
        return dataSource.cameras
    }
}

enum CameraAvailbiltyError: Error {
    case cameraNotAvailable
}
