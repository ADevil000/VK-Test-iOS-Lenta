import UIKit

class CollectionViewController: UICollectionViewController {
    
    enum Section {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Person>
    
    public lazy var dataSource = makeDataSource()
    
    var people: [Person]!
    var virusWorker: VirusWorker?
    var cellsInRow: Int = 4
    
    func makeDataSource() -> DataSource {
      let dataSource = DataSource(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, person) ->
          UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCell", for: indexPath) as! PersonCell
            cell.setupCell(person: person)
            return cell
      })
      return dataSource
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Person>

    func applySnapshot(animatingDifferences: Bool = false) {
        DispatchQueue.main.async { [self] in
            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(people)
            dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        virusWorker?.stop()
        super.viewDidDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.allowsSelection = true
        collectionView.isUserInteractionEnabled = true
        applySnapshot(animatingDifferences: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        virusWorker?.bindVC(vc: self)
        virusWorker?.start()
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let person = dataSource.itemIdentifier(for: indexPath) else {
          return
        }
        DispatchQueue.main.async {
            person.healthy = false
            self.applySnapshot()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = collectionView.bounds.width / CGFloat(cellsInRow)
        return CGSize(width: side - 10, height: side - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
}


