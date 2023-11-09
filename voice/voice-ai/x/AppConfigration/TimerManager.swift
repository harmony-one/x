import Combine
import Foundation

extension Notification.Name {
    static let timerDidFireNotification = Notification.Name("TimerManager.timerDidFire")
}

class TimerManager: ObservableObject {
    static let shared = TimerManager()
    var timerCancellable: AnyCancellable?
//    let fiveMinutes: TimeInterval = 5 * 60
    // TODO: for beta purpose, disable the timer
    let minutes: TimeInterval = 10000000000000

    func startTimer() {
        resetTimer()
    }

    func resetTimer() {
        // Cancel the previous timer if it exists
        timerCancellable?.cancel()

        // Schedule a new timer
        timerCancellable = Timer.publish(every: minutes, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { [weak self] _ in
                self?.timerDidFire()
            }
    }

    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func timerDidFire() {
        // Perform the action you want after the timer fires
        print("5 minutes have passed.")
        NotificationCenter.default.post(name: .timerDidFireNotification, object: nil)
    }
}
