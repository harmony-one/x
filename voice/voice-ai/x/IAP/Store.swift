import StoreKit
import SwiftUI

struct PurchaseView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationView {
            List {
                if store.products.isEmpty {
                    Text("Loading products...")
                } else {
                    ForEach(store.products, id: \.productIdentifier) { product in
                        productRow(for: product)
                    }
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Restore") {
                        store.restorePurchases() // Implement this in your Store class
                    }
                }
            }
        }
        .onAppear {
            store.requestProducts()
        }
    }

    @ViewBuilder
    private func productRow(for product: SKProduct) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.localizedTitle)
                    .font(.headline)
                Text(product.localizedDescription)
                    .font(.subheadline)
            }

            Spacer()

            if store.purchasedNonConsumables.contains(product.productIdentifier) {
                Text("Purchased")
                    .foregroundColor(.green)
            } else {
                Button(action: {
                    store.purchase(product)
                }) {
                    Text("Buy")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

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
        }
    }
    
    func purchase(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                complete(transaction: transaction)
            case .failed:
                failed(transaction: transaction)
            default:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        DispatchQueue.main.async {
            let productID = transaction.payment.productIdentifier

            let productType = self.productType(for: productID)
            self.addPurchased(productID, ofType: productType)

            // Obtain the transaction ID here
            let transactionID = transaction.transactionIdentifier

            // You can now use this transactionID for further processing, logging, or verification
            print("Transaction ID: \(transactionID ?? "N/A")")

            SKPaymentQueue.default().finishTransaction(transaction)
        }
    }
    
    private func failed(transaction: SKPaymentTransaction) {
        if let error = transaction.error as NSError? {
            if error.code != SKError.paymentCancelled.rawValue {
                print("Transaction Error: \(error.localizedDescription)")
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
            // Add your logic to increase consumables count
        case .nonConsumable:
            purchasedNonConsumables.insert(productID)
        case .autoRenewableSubscription, .nonRenewingSubscription:
            purchasedSubscriptions.insert(productID)
        }
    }

    enum ProductType {
        case consumable
        case nonConsumable
        case autoRenewableSubscription
        case nonRenewingSubscription
    }
}
