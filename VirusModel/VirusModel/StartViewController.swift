import UIKit

class StartViewController: UIViewController {
    @IBOutlet var numberOfPeople: UITextField!
    @IBOutlet var speedOfInfection: UITextField!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var period: UITextField!
    
    func changeEnable() {
        if let people = Int(numberOfPeople.text ?? ""),
           let speed = Int(speedOfInfection.text ?? ""),
           let time = Int(period.text ?? ""),
           people >= 0 && speed >= 0  && time > 0 {
            startButton?.isEnabled = true
        } else {
            startButton?.isEnabled = false
        }
    }
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CollectionVC") as! CollectionViewController
        vc.people = createDataSource()
        clearInput()
        show(vc, sender: sender)
    }
    
    func createDataSource() -> [Person] {
        guard let people = Int(numberOfPeople.text ?? ""),
              let speed = Int(speedOfInfection.text ?? ""),
              let time = Int(period.text ?? ""),
              people >= 0 && speed >= 0  && time > 0 else {
            return []
        }
        var dataSource: [Person] = []
        for i in 0..<people {
            dataSource.append(Person(name: "\(i + 1)"))
        }
        return dataSource
    }
    
    func clearInput() {
        numberOfPeople.text?.removeAll()
        speedOfInfection.text?.removeAll()
        period.text?.removeAll()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        changeEnable()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}

