import UIKit

class StartViewController: UIViewController {
    @IBOutlet weak var numberOfPeople: UITextField!
    @IBOutlet weak var speedOfInfection: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var period: UITextField!
    
    func changeEnable() {
        if let people = Int(numberOfPeople.text ?? ""),
           let speed = Int(speedOfInfection.text ?? ""),
           let time = Int(period.text ?? ""),
           people >= 0 && speed >= 0  && time >= 0 {
            startButton?.isEnabled = true
        } else {
            startButton?.isEnabled = false
        }
    }
    
    
    @IBAction func buttonAction(_ sender: UIButton) {
        guard let people = Int(numberOfPeople.text ?? ""),
              let speed = Int(speedOfInfection.text ?? ""),
              let time = Int(period.text ?? ""),
              people >= 0 && speed >= 0  && time >= 0 else {
            changeEnable()
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CollectionVC") as! CollectionViewController
        let dataSource = createDataSource(people)
        let virusWorker = VirusWorker()
        vc.people = dataSource
        virusWorker.setup(period: time, speed: speed)
        vc.virusWorker = virusWorker
        clearInput()
        show(vc, sender: sender)
    }

    func createDataSource(_ people: Int) -> [Person] {
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

    override func viewDidLayoutSubviews() {
        super.viewWillLayoutSubviews()
        changeEnable()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}

