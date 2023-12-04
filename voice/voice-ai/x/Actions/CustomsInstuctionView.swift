import SwiftUI
import Foundation

struct CustomInstructionsViewModifier: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                Color.black.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }

                GeometryReader { geometry in
                    VStack {
                        Spacer()

                        CustomInstructionsView()
                            .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
                            .padding(.horizontal)
//                            .padding(.top, 20)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(25)

                    }
                    .frame(maxWidth: .infinity)
                    .animation(.easeInOut)
                }
            }
        }
    }
}

struct CustomInstructionsView: View {
    @State private var inputText = ""
    @State private var selectedOption = "Default"
    @State var showTextField: Bool = false
    @State private var handler = CustomInstructionsHandler()
    
    private let selectedOptionKey = "CustomInstructionMode"
            
    var body: some View {
        VStack { // (spacing: 0)
            Text("Choose Context Instruction:")
            .padding(.top, 15)
            Picker(selection: $selectedOption, label: Text("")) {
                ForEach(handler.getOptions(), id: \.self) { option in
                    Text(option)
                        .tag(option)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .onChange(of: selectedOption, perform: { value in
                if (value == "Custom") {
                    self.showTextField = true
                } else {
                    self.showTextField = false
                }
            })
            
            if showTextField {
                TextField("Enter your Custom Instruction", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, -80)
            }
            Button("Submit") {
                saveSelectedOption()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .onAppear {
            loadSelectedOption()
        }
    }
    
    func saveSelectedOption() {
        handler.storeActiveContext(selectedOption, withText: inputText)
    }
    
    func loadSelectedOption() {
        if let selectedOption = UserDefaults.standard.string(forKey: selectedOptionKey) {
            self.selectedOption = selectedOption
        } else {
            self.selectedOption = "Custom" // .defaultInstruction
        }
    }
}

extension View {
    func customInstructionsViewSheet(isPresented: Binding<Bool>) -> some View {
        self.modifier(CustomInstructionsViewModifier(isPresented: isPresented))
    }
}
