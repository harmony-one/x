import Foundation
import OSLog
import Sentry

class TimeLogger {
    var logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "TimeLogger")
    )
    // TODO: use ContinuousClock https://stackoverflow.com/questions/24755558/measure-elapsed-time-in-swift
    private let relay = RelayAuth.shared
    private let vendor: String
    private let endpoint: String
    private var logged = false
    private var logSent = false
    private let once: Bool
    private let printDebug = AppConfig.shared.getEnableTimeLoggerPrint()
    
    private var requestNumMessages: Int32 = 0
    private var requestNumUserMessages: Int32 = 0
    private var requestTokens: Int32 = 0
    private var responseTokens: Int32 = 0
    private var requestMessage: String = ""
    private var responseMessage: String = ""
    private var cancelled: Bool = false
    private var completed: Bool = true
    private var error: String = ""

    // Checkpoints:
    private var startTime: Int64 = 0
    
    private var sttEndCheckpointTime: Int64 = 0 // STT-END step completed
    private var appSendCheckpointTime: Int64 = 0 // APP-SEND step completed
    
    private var aiFirsCheckpointTime: Int64 = 0 // APP-RES-1 step completed
    private var aiFinalCheckpointTime: Int64 = 0 // APP-RES-END step completed
    
    private var ttsInitCheckpointTime: Int64 = 0 // TTS-INIT step completed
    private var ttsFirstCheckpointTime: Int64 = 0 // TTS-STEP-1 step completed
    
    init(vendor: String, endpoint: String, once: Bool = true) {
        self.vendor = vendor
        self.endpoint = endpoint
        self.once = once
    }

    func start() {
        if self.startTime != 0 {
            return
        }
        
        startTime = Int64(Date().timeIntervalSince1970 * 1_000_000)
    }
    
    func finishSTTEnd() {
        if self.sttEndCheckpointTime != 0 {
            return
        }
        
        sttEndCheckpointTime = Int64(Date().timeIntervalSince1970 * 1_000_000)
    }
    
    func finishAppSend() {
        if self.appSendCheckpointTime != 0 {
            return
        }
        
        appSendCheckpointTime = Int64(Date().timeIntervalSince1970 * 1_000_000)
    }
    
    func finishTTSInit() {
        if self.ttsInitCheckpointTime != 0 {
            return
        }
        
        ttsInitCheckpointTime = Int64(Date().timeIntervalSince1970 * 1_000_000)
    }
    
    func finishTTSFirst() {
        if self.ttsFirstCheckpointTime != 0 {
            return
        }
        
        ttsFirstCheckpointTime = Int64(Date().timeIntervalSince1970 * 1_000_000)
    }

    func tryCheckAIReponse() {
        if aiFirsCheckpointTime != 0 {
            return
        }
        checkAIResponse()
    }

    func checkAIResponse() {
        aiFirsCheckpointTime = Int64(Date().timeIntervalSince1970 * 1_000_000)
    }

    func finishAIResponse() {
        aiFinalCheckpointTime = Int64(Date().timeIntervalSince1970 * 1_000_000)
    }
    
    func log(requestNumMessages: Int32 = 0, requestNumUserMessages: Int32 = 0, requestTokens: Int32 = 0, responseTokens: Int32 = 0, requestMessage: String = "", responseMessage: String = "", cancelled: Bool = false, completed: Bool = true, error: String = "") {
        if once, logged {
            return
        }
        if aiFinalCheckpointTime == 0 {
            finishAIResponse()
        }
        if aiFirsCheckpointTime == 0 {
            aiFirsCheckpointTime = aiFinalCheckpointTime
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
        
        let sttEndTime = sttEndCheckpointTime - startTime
        let appSendTime = appSendCheckpointTime - sttEndCheckpointTime
        let firstResponseTime = aiFirsCheckpointTime - appSendCheckpointTime
        let ttsInitTime = ttsInitCheckpointTime - aiFirsCheckpointTime
        let ttsFirstTime = ttsFirstCheckpointTime - ttsInitCheckpointTime
        let clickToSpeechTotalTime = ttsFirstCheckpointTime - startTime
        let totalResponseTime = aiFinalCheckpointTime - appSendCheckpointTime
        
        let logDetails = ClientUsageLog(
            vendor: vendor,
            endpoint: endpoint,
            requestTokens: requestTokens,
            responseTokens: responseTokens,
            requestNumMessages: requestNumMessages,
            requestNumUserMessages: requestNumUserMessages,
            requestMessage: requestMessage,
            responseMessage: responseMessage,
            cancelled: cancelled,
            completed: completed,
            error: error,
            sttEndTime: sttEndTime,
            appSendTime: appSendTime,
            firstResponseTime: firstResponseTime,
            ttsInitTime: ttsInitTime,
            ttsFirstTime: ttsFirstTime,
            clickToSpeechTotalTime: clickToSpeechTotalTime,
            totalResponseTime: totalResponseTime
        )
        if printDebug {
            logger.log("[TimeLogger] \(String(describing: logDetails))")
        }
        
        let del: Int64 = 1000
        
        logger.log("[Benchmarks]: \(String(sttEndTime / del)) + \(String(appSendTime / del)) + \(String(firstResponseTime / del)) + \(String(ttsInitTime / del)) + \(String(ttsFirstTime / del)) = \(String(clickToSpeechTotalTime / del)) ms")
        
        Task {
            await RelayAuth.shared.record(logDetails)
        }
    }
}
