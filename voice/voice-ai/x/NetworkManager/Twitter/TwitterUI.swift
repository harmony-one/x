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
    
    var body: some View {
        List(viewModel.nameDetails, id: \.id) { list in
            VStack(alignment: .leading) {
                Text(list.text ?? "Unknown")
                    .font(.headline)
                Text("Created at: \(list.createdAt ?? "Unknown")")
                    .font(.subheadline)
            }
            .padding()
        }
        .navigationTitle("List Details")
        .onAppear {
            viewModel.getListByName(name: listName)
        }
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
