import Foundation

enum Route: Hashable {
    case login
    case signup
    case dashboard
    case facility(String)
    case account
}
