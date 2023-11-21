
import Foundation
import StoreKit

class ReviewRequester {
    static let shared = ReviewRequester()
    
    // Configuration
    private var minimumSignificantEvents: Int?
    private var daysBetweenPrompts: Int?
    
    // User default keys
    private let reviewRequestCountKey = "reviewRequestCount"
    private let lastReviewRequestDateKey = "lastReviewRequestDate"
    private let significantEventsCountKey = "significantEventsCount"
    
    // Properties
    private var reviewRequestCount: Int {
        get { UserDefaults.standard.integer(forKey: reviewRequestCountKey) }
        set { UserDefaults.standard.set(newValue, forKey: reviewRequestCountKey) }
    }
    
    var lastReviewRequestDate: Date? {
        get { UserDefaults.standard.object(forKey: lastReviewRequestDateKey) as? Date }
        set { UserDefaults.standard.set(newValue, forKey: lastReviewRequestDateKey) }
    }
    
    var significantEventsCount: Int {
        get { UserDefaults.standard.integer(forKey: significantEventsCountKey) }
        set { UserDefaults.standard.set(newValue, forKey: significantEventsCountKey) }
    }
    
    // Singleton initialization with configurable parameters
    static func initialize(minimumSignificantEvents: Int, daysBetweenPrompts: Int) {
        ReviewRequester.shared.minimumSignificantEvents = minimumSignificantEvents
        ReviewRequester.shared.daysBetweenPrompts = daysBetweenPrompts
    }
    
    func logSignificantEvent() {
        print("[ReviewRequester][logSignificantEvent]")
        print("Initial significantEventsCount: \(self.significantEventsCount)")
        significantEventsCount += 1
        print("After significantEventsCount: \(self.significantEventsCount)")
        tryPromptForReview()
        print("Last significantEventsCount: \(self.significantEventsCount)")
    }
    
    func tryPromptForReview(forced: Bool = false) {
        guard forced || shouldPromptForReview() else { return }
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
            reviewRequestCount += 1
            lastReviewRequestDate = Date()
            resetSignificantEventsCount() // Reset the count after prompting for review
        }
    }
    
    private func shouldPromptForReview() -> Bool {
        // Check if significant events have occurred enough times
        guard significantEventsCount >= minimumSignificantEvents ?? 0 else { return false }
        
        // Check if the review prompt has been shown less than 3 times in the past year
        guard reviewRequestCount < 3 else { return false }
        
        // Check if the specified number of days have passed since the last review request or if it's the first time
        if let lastDate = lastReviewRequestDate {
            return Calendar.current.dateComponents([.day], from: lastDate, to: Date()).day! >= daysBetweenPrompts ?? 0
        }
        
        return true // No review has been requested before
    }
    
    private func resetSignificantEventsCount() {
        significantEventsCount = 0 // Reset the count to 0
        UserDefaults.standard.set(significantEventsCount, forKey: significantEventsCountKey)
    }
}
