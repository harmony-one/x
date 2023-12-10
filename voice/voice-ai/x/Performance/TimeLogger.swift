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
    private var appRecTimestamp: Int64 = 0
    private var sttRecTimestamp: Int64 = 0
    private var appRecEndTimestamp: Int64 = 0
    
    private var sttEndTimestamp: Int64 = 0 // STT-END step completed
    private var appSendTimestamp: Int64 = 0 // APP-SEND step completed
    
    private var appResFirstTimestamp: Int64 = 0 // APP-RES-1 step completed
    private var appResEndTimestamp: Int64 = 0 // APP-RES-END step completed
    
    private var ttsInitTimestamp: Int64 = 0 // TTS-INIT step completed
    private var appPlayFirstTimestamp: Int64 = 0 // TTS-STEP-1 step completed
    private var appPlayEndTimestamp: Int64 = 0 // TTS-END step completed
    
    init(vendor: String, endpoint: String, once: Bool = true) {
        self.vendor = vendor
        self.endpoint = endpoint
        self.once = once
    }
    
    // microseconds
    private func now() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1_000_000)
    }

    func setAppRec() {
        if appRecTimestamp != 0 {
            return
        }
        appRecTimestamp = now()
    }
    
    func setSttRec() {
        if sttRecTimestamp != 0 {
            return
        }
        sttRecTimestamp = now()
    }
    
    func setAppRecEnd() {
        if appRecEndTimestamp != 0 {
            return
        }
        appRecEndTimestamp = now()
    }
    
    func setSTTEnd() {
        if sttEndTimestamp != 0 {
            return
        }
        
        sttEndTimestamp = now()
    }
    
    func setAppSend() {
        if appSendTimestamp != 0 {
            return
        }
        
        appSendTimestamp = now()
    }
    
    func setTTSInit() {
        if ttsInitTimestamp != 0 {
            return
        }
        ttsInitTimestamp = now()
    }
    
    func setTTSFirst() {
        if appPlayFirstTimestamp != 0 {
            return
        }
        appPlayFirstTimestamp = now()
    }
    
    func setTTSEnd() {
        appPlayEndTimestamp = now()
        if appPlayFirstTimestamp == 0 {
            appPlayFirstTimestamp = appPlayEndTimestamp
        }
    }

    func setAppResFirst() {
        if appResFirstTimestamp != 0 {
            return
        }
        appResFirstTimestamp = now()
    }

    func setAppResEnd() {
        appResEndTimestamp = now()
        if appResFirstTimestamp == 0 {
            appResFirstTimestamp = appResEndTimestamp
        }
    }
    
    func setInferenceStats(requestNumMessages: Int32 = 0, requestNumUserMessages: Int32 = 0, requestTokens: Int32 = 0, responseTokens: Int32 = 0, requestMessage: String = "", responseMessage: String = "", cancelled: Bool = false, completed: Bool = true, error: String = "") {
        if once, logged {
            return
        }
        if appResEndTimestamp == 0 {
            setAppResEnd()
        }
        if appResFirstTimestamp == 0 {
            appResFirstTimestamp = appResEndTimestamp
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
        
        let currentTime = now()
        
        if ttsInitTimestamp == 0 {
            ttsInitTimestamp = currentTime
        }
        if appPlayFirstTimestamp == 0 {
            appPlayFirstTimestamp = currentTime
        }
        if appPlayEndTimestamp == 0 {
            appPlayEndTimestamp = currentTime
        }
        
        let sttPreparationTime = sttRecTimestamp - appRecTimestamp
        let sttFinalizationTime = sttEndTimestamp - appRecEndTimestamp
        let requestPreparationTime = appSendTimestamp - sttEndTimestamp
        let firstResponseTime = appResFirstTimestamp - appSendTimestamp
        let ttsPreparationTime = ttsInitTimestamp - appResFirstTimestamp
        let firstUtteranceTime = appPlayFirstTimestamp - ttsInitTimestamp
        let totalTtsTime = appPlayEndTimestamp - ttsInitTimestamp
        let totalClickToSpeechTime = appPlayFirstTimestamp - appRecEndTimestamp
        let totalResponseTime = appResEndTimestamp - appSendTimestamp
        
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
            sttPreparationTime: sttPreparationTime,
            sttFinalizationTime: sttFinalizationTime,
            requestPreparationTime: requestPreparationTime,
            firstResponseTime: firstResponseTime,
            ttsPreparationTime: ttsPreparationTime,
            firstUtteranceTime: firstUtteranceTime,
            totalTtsTime: totalTtsTime,
            totalClickToSpeechTime: totalClickToSpeechTime,
            totalResponseTime: totalResponseTime
        )
        if printDebug {
            logger.log("[TimeLogger] \(String(describing: logDetails))")
        }
        
        let del: Int64 = 1000
        
        logger.log("[TimeLogger][Benchmarks]: \(String(sstFinalizationTime / del)) + \(String(requestPreparationTime / del)) + \(String(firstResponseTime / del)) + \(String(ttsPreparationTime / del)) + \(String(firstUtteranceTime / del)) = \(String(totalClickToSpeechTime / del)) ms")
        
        Task {
            await RelayAuth.shared.record(logDetails)
        }
    }
}
