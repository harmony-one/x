import SwiftUI
import Foundation

struct CustomInstructionsViewModifier: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                CustomInstructionsView()
                    .padding()
            }
        }
    }
}

struct CustomInstructionsView: View {
    @State private var selectedOption = 0
    @State private var inputText = ""
    
    let options = ["Default", "Quick Facts", "Interactive Tour", "Custom"]
    
    var showTextField: Bool {
        return selectedOption == 3 // Show the TextField when Option 3 is selected
    }
    
    var body: some View {
        VStack(spacing: 15) {
            Picker(selection: $selectedOption, label: Text("Options")) {
                ForEach(0..<options.count) { index in
                    Text(self.options[index])
                }
            }
            .pickerStyle(DefaultPickerStyle())
            
            if showTextField {
                TextField("Enter your Custom Instruction", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Add additional views or actions as needed
            
            Button("Submit") {
                // Handle submit action
                print("Selected option: \(self.options[self.selectedOption])")
                print("Input text: \(self.inputText)")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .padding(.bottom, (UIApplication.shared.windows.last?.safeAreaInsets.bottom)! + 10)
        .padding(.horizontal)
        .padding(.top,60)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(25)
    }
}

extension View {
    func customInstructionsViewSheet(isPresented: Binding<Bool>) -> some View {
        self.modifier(CustomInstructionsViewModifier(isPresented: isPresented))
    }
}
