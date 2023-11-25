import Foundation
import Sentry

class TimeLogger {
    private let relay = RelayAuth.shared
    private var startTime: Int64
    private var firstCheckpointTime: Int64 = 0
    private var finalCheckpointTime: Int64 = 0
    private let vendor: String
    private let endpoint: String
    private var logged = false
    private let once: Bool
    private let printDebug = AppConfig.shared.getEnableTimeLoggerPrint()
    
    init(vendor: String, endpoint: String, once: Bool = true) {
        self.vendor = vendor
        self.endpoint = endpoint
        self.once = once
        startTime = Int64(Date().timeIntervalSince1970 * 1000000)
    }
    
    func reset() {
        startTime = Int64(Date().timeIntervalSince1970 * 1000000)
        firstCheckpointTime = 0
        finalCheckpointTime = 0
    }
    
    func tryCheck() {
        if firstCheckpointTime != 0 {
            return
        }
        check()
    }
    
    func check() {
        firstCheckpointTime = Int64(Date().timeIntervalSince1970 * 1000000)
    }
    
    func stop() {
        finalCheckpointTime = Int64(Date().timeIntervalSince1970 * 1000000)
    }
    
    func log(requestNumMessages: Int32 = 0, requestNumUserMessages: Int32 = 0, requestTokens: Int32 = 0, responseTokens: Int32 = 0, requestMessage: String = "", responseMessage: String = "", cancelled: Bool = false, completed: Bool = true, error: String = "") {
        if once, logged {
            return
        }
        if finalCheckpointTime == 0 {
            stop()
        }
        if firstCheckpointTime == 0 {
            firstCheckpointTime = finalCheckpointTime
        }
        let firstResponseTime = firstCheckpointTime - startTime
        let totalResponseTime = finalCheckpointTime - startTime
        logged = true
        let u = ClientUsageLog(
            vendor: vendor,
            endpoint: endpoint,
            requestTokens: requestTokens,
            responseTokens: responseTokens,
            firstResponseTime: firstResponseTime,
            totalResponseTime: totalResponseTime,
            requestNumMessages: requestNumMessages,
            requestNumUserMessages: requestNumUserMessages,
            requestMessage: requestMessage,
            responseMessage: responseMessage,
            cancelled: cancelled,
            completed: completed,
            error: error
        )
        if printDebug {
            print("[TimeLogger]", u)
        }
        Task {
            await RelayAuth.shared.record(u)
        }
    }
}
