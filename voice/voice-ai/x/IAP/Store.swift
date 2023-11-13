import StoreKit
import Sentry
import SwiftUI

class Store: NSObject,ObservableObject,SKProductsRequestDelegate, SKPaymentTransactionObserver {
    private var productIDs = ["0001"]
    
    @Published var products = [SKProduct]()
    
    @Published var purchasedNonConsumables = Set<String>()
    @Published var purchasedNonRenewables = Set<String>()
    
    @Published var purchasedConsumables = [String]()
    @Published var purchasedSubscriptions = Set<String>()
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        requestProducts()
    }
    
    func requestProducts() {
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
            if response.invalidProductIdentifiers.count > 0 {
                SentrySDK.capture(message: "[Store][ProductsRequest] Invalid Product IDs: \(response.invalidProductIdentifiers)")
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                DispatchQueue.main.async {
                    self.complete(transaction: transaction)
                }
            case .failed:
                DispatchQueue.main.async {
                    self.failed(transaction: transaction)
                }
            default:
                break
            }
        }
    }
    
    func purchase(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // As we currently have only one, it's been directly assigned to purchases.
    func purchaseConsumable() {
        guard self.products.count > 0,
              let product = self.products.first  else {
            SentrySDK.capture(message: "[Store][PurchaseConsumable] No items to pruchase")
            return
        }
        self.purchase(product)
    }
    
    func isProductPurchased(_ productID: String) -> Bool {
        return purchasedNonConsumables.contains(productID) ||
        purchasedNonRenewables.contains(productID) ||
        purchasedSubscriptions.contains(productID)
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        DispatchQueue.main.async {
            let productID = transaction.payment.productIdentifier
            
            let productType = self.productType(for: productID)
            self.addPurchased(productID, ofType: productType)
            
            // Obtain the transaction ID here
            let transactionID = transaction.transactionIdentifier
            
            // You can now use this transactionID for further processing, logging, or verification
            SentrySDK.capture(message:"Transaction ID: \(transactionID ?? "N/A")")
            
            // Consider server-side validation of the receipt here
            
            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        if let error = transaction.error as NSError? {
            if error.code != SKError.paymentCancelled.rawValue {
                SentrySDK.capture(message:"[Store][failed] Transaction Error: \(error.localizedDescription)")
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func productType(for productID: String) -> ProductType {
        switch productID {
            // Replace these with your actual product IDs and their types
        case "0001":
            return .consumable
        case "com.yourapp.nonConsumableProductID":
            return .nonConsumable
        case "com.yourapp.autoRenewableSubscriptionProductID":
            return .autoRenewableSubscription
        case "com.yourapp.nonRenewingSubscriptionProductID":
            return .nonRenewingSubscription
        default:
            fatalError("Unknown product ID")
        }
    }
    
    private func addPurchased(_ productID: String, ofType productType: ProductType) {
        switch productType {
        case .consumable:
            purchasedConsumables.append(productID)
            Persistence.increaseConsumablesCount(creditsAmount: 500)
        case .nonConsumable:
            purchasedNonConsumables.insert(productID)
        case .autoRenewableSubscription, .nonRenewingSubscription:
            purchasedSubscriptions.insert(productID)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        // Implement logic here to decide whether to continue the transaction
        // For now, returning true to allow the transaction
        return true
    }
    
    enum ProductType {
        case consumable
        case nonConsumable
        case autoRenewableSubscription
        case nonRenewingSubscription
    }
}
