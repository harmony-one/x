import SwiftUI

struct TwitterListView: View {
    @StateObject var viewModel = TwitterManager()
    @State private var showingAddForm = false
    @State private var showingEditForm = false
    @State private var selectedList: TwitterModel?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.twitterLists, id: \.id) { list in
                    NavigationLink(destination: TwitterDetailView(listName: list.name ?? "", viewModel: viewModel)) {
                        Text(list.name ?? "Unnamed List")
                    }
                    .contextMenu {
                        Button("Edit") {
                            selectedList = list
                            showingEditForm = true
                        }
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationTitle("Twitter Lists")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showingAddForm = true
                    }
                }
            }
            .sheet(isPresented: $showingEditForm) {
                if let selectedList = selectedList {
                    EditTwitterListView(isPresented: $showingEditForm, viewModel: viewModel, list: selectedList)
                }
            }
            .sheet(isPresented: $showingAddForm) {
                AddTwitterListView(isPresented: $showingAddForm, viewModel: viewModel)
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            guard let listId = viewModel.twitterLists[index].listId else {
                return
            }
            viewModel.deleteList(listId: listId)
        }
    }
}

struct TwitterDetailView: View {
    var listName: String
    @ObservedObject var viewModel: TwitterManager
    @State private var isFavorite: Bool

    init(listName: String, viewModel: TwitterManager) {
        self.listName = listName
        self.viewModel = viewModel
        // Retrieve the favorite status and load the combined text
        self._isFavorite = State(initialValue: UserDefaults.standard.bool(forKey: "favorite_\(listName)"))
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: toggleFavorite) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .foregroundColor(isFavorite ? .yellow : .gray)
                }
                Text("Make it favorite for talk to me")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            
            List(viewModel.nameDetails, id: \.id) { list in
                VStack(alignment: .leading) {
                    Text(list.text ?? "Unknown")
                        .font(.headline)
                    Text("Created at: \(list.createdAt ?? "Unknown")")
                        .font(.subheadline)
                }
                .padding()
            }
        }
        .navigationTitle("List Details")
        .onAppear {
            viewModel.getListByName(name: listName)
        }
    }

    private func toggleFavorite() {
        isFavorite.toggle()
        UserDefaults.standard.set(isFavorite, forKey: "favorite_\(listName)")

        if isFavorite {
            saveListText()
        } else {
            removeSavedListText()
        }
    }

    private func saveListText() {
        let combinedText = viewModel.nameDetails.compactMap { $0.text }.joined(separator: "\n")
        UserDefaults.standard.set(combinedText, forKey: "combinedText_\(listName)")
    }

    private func removeSavedListText() {
        UserDefaults.standard.removeObject(forKey: "combinedText_\(listName)")
    }

}

struct EditTwitterListView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: TwitterManager
    var list: TwitterModel
    @State private var listName: String
    @State private var isActive: Bool
    
    init(isPresented: Binding<Bool>, viewModel: TwitterManager, list: TwitterModel) {
        self._isPresented = isPresented
        self.viewModel = viewModel
        self.list = list
        self._listName = State(initialValue: list.name ?? "")
        self._isActive = State(initialValue: list.isActive ?? false)
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("List Name", text: $listName)
                Toggle("Is Active", isOn: $isActive)
                Button("Update List") {
                    viewModel.updateList(listId: list.listId ?? "", isActive: isActive)
                    isPresented = false
                }
            }
            .navigationTitle("Edit List")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

struct AddTwitterListView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: TwitterManager
    @State private var listName = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("List Name", text: $listName)
                Button("Add List") {
                    viewModel.addList(name: listName)
                    isPresented = false // Dismiss the view
                }
            }
            .navigationTitle("Add New List")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
}
