import Foundation


class Person: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(healthy)
        hasher.combine(name)
    }

    static func == (lhs: Person, rhs: Person) -> Bool {
        (lhs.id == rhs.id) && (lhs.name == rhs.name) && (lhs.healthy == rhs.healthy)
    }

    let id: UUID
    var healthy: Bool
    let name: String
    
    
    init(name: String) {
        healthy = true
        self.name = name
        self.id = UUID()
        
    }
}
