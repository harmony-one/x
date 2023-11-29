import StoreKit

class Store: ObservableObject {
//    private var productIDs = ["com.country.app.purchase.3day"]
    private var productIDs = ["com.country.x.purchase.3day"]
    @Published var products = [Product]()
    @Published var purchasedNonConsumables = Set<Product>()
    @Published var purchasedNonRenewables = Set<Product>()
    @Published var purchasedConsumables = [Product]()
    @Published var purchasedSubscriptions = Set<Product>()
    @Published var entitlements = [Transaction]()
    @Published var isPurchasing: Bool = false
    var transactionListener: Task<Void, Error>?

    init() {
        transactionListener = listenForTransactions()
        Task {
            await requestProducts()
            // Must be called after the products are already fetched
            await updateCurrentEntitlements()
        }
    }

    @MainActor
    func requestProducts() async {
        do {
            print("[Store] ", productIDs)
            products = try await Product.products(for: productIDs)
            print("[Store] Products:", products)
        } catch {
            print(error)
            products = []
        }
    }

    @MainActor
    func purchase(_ product: Product) async throws {
        isPurchasing = true
        let result = try await product.purchase()
        switch result {
        case let .success(transacitonVerification):
            await handle(transactionVerification: transacitonVerification)
        case .userCancelled:
            isPurchasing = false
        default:
            return
        }
    }

    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                await self.handle(transactionVerification: result)
            }
        }
    }

    @MainActor
    @discardableResult
    private func handle(transactionVerification result: VerificationResult<Transaction>) async -> Transaction? {
        isPurchasing = false
        switch result {
        case let .verified(transaction):
            guard let product = products.first(where: {
                $0.id == transaction.productID
            }) else {
                return transaction
            }

            guard !transaction.isUpgraded else { return nil }

            UserAPI().purchase(transactionId: String(transaction.id))

            addPurchased(product)

            await transaction.finish()

            return transaction
        default:
            return nil
        }
    }

    @MainActor
    private func updateCurrentEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if let transaction = await handle(transactionVerification: result) {
                entitlements.append(transaction)
            }
        }
    }

    private func addPurchased(_ product: Product) {
        switch product.type {
        case .consumable:
            purchasedConsumables.append(product)
        //   Persistence.updateBooster3DayPurchaseTime()
//            Persistence.increaseConsumablesCount(creditsAmount: 500)
        case .nonConsumable:
            purchasedNonConsumables.insert(product)
        case .nonRenewable:
            purchasedNonRenewables.insert(product)
        case .autoRenewable:
            purchasedSubscriptions.insert(product)
        default:
            return
        }
    }
}
