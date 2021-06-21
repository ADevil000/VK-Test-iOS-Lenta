import Foundation


class Person: Hashable {
    
    static let syncQueue: DispatchQueue = DispatchQueue(label: "SyncQueue")
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(healthy)
        hasher.combine(name)
    }

    static func == (lhs: Person, rhs: Person) -> Bool {
        (lhs.id == rhs.id) && (lhs.name == rhs.name) && (lhs.healthy == rhs.healthy)
    }

    let id: UUID
    private var threadSafeHealth: SafeBool
    var healthy: Bool {
        get {
            let ans = SafeBool()
            Person.syncQueue.sync {
                ans.value = threadSafeHealth.value
            }
            return ans.value
        }
        set {
            Person.syncQueue.async(flags: .barrier) {
                self.threadSafeHealth.value = newValue
            }
        }
    }
    let name: String
    
    init(name: String) {
        threadSafeHealth = SafeBool(value: true)
        self.name = name
        self.id = UUID()
    }
}


class SafeBool: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    static func == (lhs: SafeBool, rhs: SafeBool) -> Bool {
        lhs.value == rhs.value
    }

    private var privateValue: Bool
    
    init(value: Bool) {
        privateValue = value
    }
    
    init() {
        privateValue = false
    }
    
    var value: Bool {
        get {
            return privateValue
        }
        set {
            privateValue = newValue
        }
    }
}
