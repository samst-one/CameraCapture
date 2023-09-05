import Foundation

class RetrieveAvailableCamerasUseCase {
    
    private let dataSource: DataSource
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    func get() -> [Device] {
        return dataSource.cameras
    }
    
    var selectedCamera: Device? {
        return dataSource.selectedCamera
    }
}
