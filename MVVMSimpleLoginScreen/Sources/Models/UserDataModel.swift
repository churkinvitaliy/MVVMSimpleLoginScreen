import Foundation

// Model structure representing user credentials
struct Credentials {
    var username: String
    var password: String
}

// Extension for additional functionality related to Credentials
extension Credentials {
    // Static array containing predefined user credentials for demonstration purposes
    static var users: [Credentials] = [
        Credentials(username: "admin", password: "admin"),
        Credentials(username: "user", password: "user")
    ]
}
