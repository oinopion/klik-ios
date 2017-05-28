import UIKit

class CounterViewController: UIViewController {

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    var index: Int = 0
    var counter: Counter!

    class func fromStoryboard(for counter: Counter, at index: Int) -> CounterViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(
            withIdentifier: "CounterViewController") as! CounterViewController

        controller.counter = counter
        controller.index = index

        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateName()
        updateValue()
    }

    @IBAction func incrementPressed() {
        AppDelegate.repo.incrementCounter(counter)
        updateValue()
    }

    func updateName() {
        nameLabel.text = counter.name
    }

    func updateValue() {
        let padded = String(format: "%05d", counter.value)
        valueLabel.text = padded
    }

}
