import UIKit

class PersonCell: UICollectionViewCell {
    @IBOutlet weak var personName: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.layer.cornerRadius = contentView.frame.size.width / 4
        contentView.clipsToBounds = true
        contentView.layer.borderColor = CGColor(gray: 0.5, alpha: 0.5)
        contentView.layer.borderWidth = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        personName.sizeToFit()
        personName.center = contentView.center
    }
    
    override func prepareForReuse() {
        contentView.backgroundColor = .white
        personName.text = ""
    }
    
    func setupCell(person: Person) {
        personName.text = person.name
        contentView.backgroundColor = person.healthy ? .green : .red
    }
    
}
