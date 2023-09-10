import XCTest
@testable import CameraCapture

class ZoomTests: XCTestCase {
    
    let session = SpyCameraSession(hasCamera: true, hasStarted: true)
    var controller: DefaultCamera!
    let zoomController = SpyZoomController()
    let dataSource = MockDataSource()
    
    override func setUp() {
        super.setUp()
        controller = DefaultCameraFactory.make(dataSource: dataSource,
                                               session: session,
                                               controller: SpyCameraController(),
                                               flashController: SpyFlashController(),
                                               zoomController: zoomController)
    }
    
    func testWhenNoCameraIsSelected_ThenZoomFails() {
        do {
            try controller.zoom(to: 2)
        } catch let error as ZoomError {
            XCTAssertEqual(error, .noSelectedCamera)
            return
        } catch {
            XCTFail("Expecting ZoomError.")
            return
        }
        
        XCTFail("Expecting error.")
    }
    
    func testWhenCameraIsSelected_AndZoomWithinBoundariesOfDevice_ThenZoomIsSuccesful() {
        dataSource.selectedCameraToReturn = Device(id: "1",
                                                   type: .tripleCamera,
                                                   position: .back,
                                                   hasFlash: false,
                                                   isFlashOn: true,
                                                   zoomOptions: [],
                                                   currentZoom: 1.0,
                                                   maxZoom: 10,
                                                   minZoom: 0.5)
        
        try? controller.zoom(to: 2)
        
        XCTAssertEqual(zoomController.zoomValue, 4)
    }
    
    func testWhenZoomIsSuccesful_ThenObserversAreNotified() {
        let zoomObserver = SpyZoomObserver()
        
        dataSource.selectedCameraToReturn = Device(id: "1",
                                                   type: .tripleCamera,
                                                   position: .back,
                                                   hasFlash: false,
                                                   isFlashOn: true,
                                                   zoomOptions: [],
                                                   currentZoom: 1.0,
                                                   maxZoom: 10,
                                                   minZoom: 0.5)
        controller.add(zoomObserver: zoomObserver)
        try? controller.zoom(to: 2)

        XCTAssertEqual(zoomObserver.magnificationValue, 2)
    }
    
    func testWhenCameraIsSelected_AndZoomBelowMinimumZoom_ThenZoomReturnError() {
        dataSource.selectedCameraToReturn = Device(id: "1",
                                                   type: .tripleCamera,
                                                   position: .back,
                                                   hasFlash: false,
                                                   isFlashOn: true,
                                                   zoomOptions: [],
                                                   currentZoom: 1.0,
                                                   maxZoom: 10,
                                                   minZoom: 0.5)
        
        do {
            try controller.zoom(to: 0.4)
        } catch let error as ZoomError {
            XCTAssertEqual(error, .zoomOutsideOfBounds)
            return
        } catch {
            XCTFail("Expecting ZoomError.")
            return
        }
        
        XCTFail("Expecting error.")
    }
    
    func testWhenCameraIsSelected_AndZoomIsAboveMaximumZoom_ThenZoomReturnError() {
        dataSource.selectedCameraToReturn = Device(id: "1",
                                                   type: .tripleCamera,
                                                   position: .back,
                                                   hasFlash: false,
                                                   isFlashOn: true,
                                                   zoomOptions: [],
                                                   currentZoom: 1.0,
                                                   maxZoom: 10,
                                                   minZoom: 0.5)
                
        do {
            try controller.zoom(to: 11)
        } catch let error as ZoomError {
            XCTAssertEqual(error, .zoomOutsideOfBounds)
            return
        } catch {
            XCTFail("Expecting ZoomError.")
            return
        }
        
        XCTFail("Expecting error.")
    }
    
    func testWhenZoomFails_AndZoomErrorIsThrown_ThenZoomErrorIsReturned() {
        zoomController.errorToThrow = ZoomError.zoomOutsideOfBounds
        dataSource.selectedCameraToReturn = Device(id: "1",
                                                   type: .tripleCamera,
                                                   position: .back,
                                                   hasFlash: false,
                                                   isFlashOn: true,
                                                   zoomOptions: [],
                                                   currentZoom: 1.0,
                                                   maxZoom: 10,
                                                   minZoom: 0.5)
                
        do {
            try controller.zoom(to: 3)
        } catch let error as ZoomError {
            XCTAssertEqual(error, .zoomOutsideOfBounds)
            return
        } catch {
            XCTFail("Expecting ZoomError.")
            return
        }
        
        XCTFail("Expecting error.")
    }
    
    func testWhenZoomFails_AndUnknownErrorIsReturned_ThenUnknownZoomErrorIsReturned() {
        zoomController.errorToThrow = FakeError.fakeError
        dataSource.selectedCameraToReturn = Device(id: "1",
                                                   type: .tripleCamera,
                                                   position: .back,
                                                   hasFlash: false,
                                                   isFlashOn: true,
                                                   zoomOptions: [],
                                                   currentZoom: 1.0,
                                                   maxZoom: 10,
                                                   minZoom: 0.5)
                
        do {
            try controller.zoom(to: 3)
        } catch let error as ZoomError {
            XCTAssertEqual(error, .unknownError)
            return
        } catch {
            XCTFail("Expecting ZoomError.")
            return
        }
        
        XCTFail("Expecting error.")
    }
    
    func testWhenUserZoomsInOnView_AndDeviceIsSelected_ThenZoomIsSuccesful() {
        dataSource.selectedCameraToReturn = Device(id: "1",
                                                   type: .tripleCamera,
                                                   position: .back,
                                                   hasFlash: false,
                                                   isFlashOn: true,
                                                   zoomOptions: [],
                                                   currentZoom: 1.0,
                                                   maxZoom: 10,
                                                   minZoom: 0.5)
        
        let setZoomUseCase = SetZoomUseCase(zoomController: zoomController, dataSource: dataSource)
        let presenter = DefaultPresenter(setZoomUseCase: setZoomUseCase, retrieveSelectedCameras: RetrieveAvailableCamerasUseCase(dataSource: dataSource))
        
        presenter.didZoomTo(2.4)
        
        XCTAssertEqual(zoomController.zoomValue, 4.8)
    }
    
    func testWhenUserZoomsInOnView_AndDeviceIsntSelected_ThenZoomIsSuccesful() {
        let setZoomUseCase = SetZoomUseCase(zoomController: zoomController, dataSource: dataSource)
        let presenter = DefaultPresenter(setZoomUseCase: setZoomUseCase, retrieveSelectedCameras: RetrieveAvailableCamerasUseCase(dataSource: dataSource))
        
        presenter.didZoomTo(2.4)
        
        XCTAssertEqual(zoomController.zoomValue, 0)
    }
}

enum FakeError: Error {
    case fakeError
}

class SpyZoomObserver: ZoomObserver {
    var magnificationValue: Double = 0
    func didUpdateZoom(to magnification: Double) {
        self.magnificationValue = magnification
    }
}

class SpyZoomController: ZoomController {
    
    var zoomValue: Double = 0
    var errorToThrow: Error?
    
    func zoom(to value: Double) throws {
        if let errorToThrow = errorToThrow {
            throw errorToThrow
        }
        zoomValue = value
    }
}
