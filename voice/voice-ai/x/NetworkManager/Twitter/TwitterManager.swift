import SwiftUI

class TwitterManager: ObservableObject {
    @Published var twitterLists: [TwitterModel] = []
    @Published var nameDetails: [TwitterModel] = []
    
    init() {
        fetchLists()
    }
    
    func fetchLists() {
        // Assuming getTwitterList is a method that fetches the lists
        // Replace YourAPI with the actual class or struct that has the getTwitterList method
        TwitterAPI().getTwitterList { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedLists):
                    self.twitterLists = fetchedLists.data
                case .failure(let error):
                    print("Error fetching lists: \(error)")
                    // Handle the error appropriately
                }
            }
        }
    }
    
    func addList(name: String) {
        // Assuming 'name' is the name of the new list
        TwitterAPI().addTwitterList(listId: UUID().uuidString, name: name) {_ in
            // Handle the response here, such as refreshing the list
            self.fetchLists()
        }
    }
    
    func updateList(listId: String, isActive: Bool) {
        TwitterAPI().updateTwitterList(listId: listId, isActive: isActive) {_ in
            // Handle the response, such as updating the list
            self.fetchLists()
        }
    }
    
    func deleteList(listId: String) {
        TwitterAPI().deleteTwitter(listId: listId) { status in
            // Handle the response, such as removing the deleted list
            if status {
                self.fetchLists()
            }
        }
    }
    
    func getListByName(name: String) {
        TwitterAPI().getTwitterListBy(name: name) { result in
            switch result {
            case .success(let fetchedLists):
                self.nameDetails = fetchedLists.data
            case .failure(let error):
                print("Error fetching lists: \(error)")
                // Handle the error appropriately
            }
        }
    }
}
