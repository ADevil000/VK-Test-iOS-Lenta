import Foundation

class VirusWorker {
    let queueForUI: DispatchQueue
    let queueForCalculation: DispatchQueue
    var scheduler: DispatchSourceTimer?
    var period: Int
    var speed: Int
    weak var collectionVC: CollectionViewController?
    var dataSource: [Person]?
    
    init() {
        queueForUI = DispatchQueue.main
        queueForCalculation = DispatchQueue.global()
        period = 0
        speed = 0
    }
    
    func setup(period: Int, speed: Int) {
        self.period = period
        self.speed = speed
    }
    
    func bindVC(vc: CollectionViewController) {
        collectionVC = vc
        dataSource = vc.people
    }
    
    func start() {
        print(#function)
        guard period > 0 && speed > 0 else {
            return
        }
        scheduler = DispatchSource.makeTimerSource(flags: [], queue: queueForCalculation)
        scheduler?.schedule(deadline: .now() + DispatchTimeInterval.seconds(period), repeating: Double(period))
        scheduler?.setEventHandler { [self] in
            print(#function, "in closure")
            guard let inRow = collectionVC?.cellsInRow,
                  let end = dataSource?.count
            else {
                return
            }
            var idOfInfected: [Int] = []
            for i in 0..<end  {
                if !dataSource![i].healthy {
                    idOfInfected.append(i)
                }
            }
            let idForInfection = simulateInfection(idOfInfected, inRow, end)
            idForInfection.forEach() {
                id in
                dataSource![id].healthy = false
            }
            queueForUI.async {
                collectionVC?.applySnapshot()
            }
        }
        scheduler?.resume()
    }
    
    func simulateInfection(_ idOfInfected: [Int], _ inRow: Int, _ elements: Int) -> Set<Int> {
        var ans: Set<Int> = []
        idOfInfected.forEach() {
            id in
            ans.formUnion(fillPotentialId(id, inRow, elements))
        }
        return ans
    }
    
    func fillPotentialId(_ id: Int, _ inRow: Int, _ elements: Int) -> [Int] {
        var possible: [Int] = []
        possible.append(id - inRow)
        possible.append(id - inRow - 1)
        possible.append(id - inRow + 1)
        possible.append(id + inRow)
        possible.append(id + inRow - 1)
        possible.append(id + inRow + 1)
        possible.append(id - 1)
        possible.append(id + 1)
        possible = possible.filter() {
            idNear in
            guard idNear >= 0 && idNear < elements else {
                return false
            }
            if (id % inRow == 0 && idNear % inRow == inRow - 1)
                || (id % inRow == inRow - 1 && idNear % inRow == 0) {
                return false
            }
            return true
        }
        possible.shuffle()
        if possible.count - min(8, speed) > 0 {
            possible.removeLast(possible.count - min(8, speed))
        }
        return possible
    }
    
    func stop() {
        dataSource = nil
        collectionVC = nil
        scheduler?.cancel()
    }
}
