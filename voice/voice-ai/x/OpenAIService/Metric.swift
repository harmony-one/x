import Foundation

class Metric {
    private let relay = RelayAuth.shared
    private var startTime = Int64(NSDate().timeIntervalSince1970 * 1000)
    private var firstCheckpointTime: Int64 = 0
    private var finalCheckpointTime: Int64 = 0
    private let vendor: String
    private let endpoint: String
    
    init(vendor: String, endpoint: String) {
        self.vendor = vendor
        self.endpoint = endpoint
    }
    
    func start() {
        startTime = Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func check() {
        firstCheckpointTime = Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func stop() {
        finalCheckpointTime = Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func log() async {

    }
}
