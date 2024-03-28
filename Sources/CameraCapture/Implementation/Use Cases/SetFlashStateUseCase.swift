import Foundation

class SetFlashStateUseCase {

    private let dataSource: FlashDataSource
    private let session: CameraSesion

    init(session: CameraSesion,
         dataSource: FlashDataSource) {
        self.session = session
        self.dataSource = dataSource
    }
    
    func setFlashState(state: FlashState) {
        guard let selectedCamera = session.selectedCamera else {
            return
        }
        dataSource.set(deviceId: selectedCamera.id, state: state)
    }
}
