import Foundation
import Combine

protocol LoginViewModelProtocol: AnyObject {
    var selectedColor: String? { get }
    var selectedText: String? { get }
    var cancellables: Set<AnyCancellable> { get set }
    func authenticate(username: String, password: String)
}

class LoginViewModel: LoginViewModelProtocol {
    // Published properties to observe changes in the UI
    @Published var selectedColor: String?
    @Published var selectedText: String?

    // Set to hold Combine cancellables to manage subscriptions
    var cancellables = Set<AnyCancellable>()

    // Function to authenticate the user based on provided credentials
    func authenticate(username: String, password: String) {
        // Check if the provided credentials are valid
        let isValid = isValidCredentials(username: username, password: password)

        // Update UI properties based on authentication result
        if isValid {
            selectedText = "Привет, \(username.capitalized)!"
            selectedColor = "green"
        } else {
            selectedText = "Неверный логин или пароль!"
            selectedColor = "red"
        }
    }

    // Private helper function to check if the credentials are valid
    private func isValidCredentials(username: String, password: String) -> Bool {
        // Check if the provided username and password match the credentials from the model
        return Credentials.users.contains{ $0.username == username && $0.password == password }
    }
}
