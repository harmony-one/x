import Foundation
import Sentry
import OSLog

class TimeLogger {
    var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "TimeLogger")
    )
    // TODO: use ContinuousClock https://stackoverflow.com/questions/24755558/measure-elapsed-time-in-swift
    private let relay = RelayAuth.shared
    private var startTime: Int64
    private var firstCheckpointTime: Int64 = 0
    private var finalCheckpointTime: Int64 = 0
    private let vendor: String
    private let endpoint: String
    private var logged = false
    private var logSent = false
    private let once: Bool
    private let printDebug = AppConfig.shared.getEnableTimeLoggerPrint()
    
    private var requestNumMessages: Int32 = 0
    private var requestNumUserMessages: Int32 = 0
    private var  requestTokens: Int32 = 0
    private var responseTokens: Int32 = 0
    private var requestMessage: String = ""
    private var responseMessage: String = ""
    private var cancelled: Bool = false
    private var completed: Bool = true
    private var error: String = ""
    private var ttsTime: Int64 = 0
    private var sttTime: Int64 = 0
    private var audioCapturingDelay: Int64 = 0
    
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
    
    func logTTS(ttsTime: Int64) {
        self.ttsTime = ttsTime
    }
    
    func logSTT(sttTime: Int64) {
        self.sttTime = sttTime
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
        logged = true
        
        self.requestNumMessages = requestNumMessages
        self.requestNumUserMessages = requestNumUserMessages
        self.requestTokens = requestTokens
        self.responseTokens = responseTokens
        self.requestMessage = requestMessage
        self.responseMessage = responseMessage
        self.cancelled = cancelled
        self.completed = completed
        self.error = error
    }
    
    func sendLog() {
        if logSent {
            return
        }
        
        logSent = true
        
        let firstResponseTime = firstCheckpointTime - startTime
        let totalResponseTime = finalCheckpointTime - startTime
        
        let logDetails = ClientUsageLog(
            vendor: vendor,
            endpoint: endpoint,
            requestTokens: requestTokens,
            responseTokens: responseTokens,
            ttsTime: ttsTime,
            sttTime: sttTime,
            audioCapturingDelay: audioCapturingDelay,
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
            self.logger.log("[TimeLogger] \(String(describing: logDetails))")
        }
        Task {
            await RelayAuth.shared.record(logDetails)
        }
    }
}
