import UIKit

class RootViewController: UIViewController {
    var pageViewController: UIPageViewController!
    var currentViewController: CounterViewController {
        return pageViewController.viewControllers![0] as! CounterViewController
    }

    var counters = [Counter]()
    var currentIndex = 0
    var currentCounter: Counter {
        return counters[currentIndex]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshCounters()
        setupPageViewController()
    }

    @IBAction func addCounterPressed(_ sender: Any) {
        let counter = AppDelegate.repo.addCounter()
        counters.append(counter)
        scrollToTheEnd()
    }

    @IBAction func editCounterPressed(_ sender: Any) {
        let alertController = UIAlertController(
            title: "Edit counter name",
            message: "Try emojis for extra fun! ✨",
            preferredStyle: .alert)

        alertController.addTextField() { [unowned self] textField in
            textField.placeholder = "Counter name"
            textField.text = self.currentCounter.name
        }

        let okAction = UIAlertAction(title: "OK", style: .default) {
            [unowned self, unowned alertController] (_) in
            let counterNameField = alertController.textFields![0] as UITextField
            if let name = counterNameField.text {
                AppDelegate.repo.setCounterName(self.currentCounter, name: name)
                self.currentViewController.counterDidUpdate()
            }
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(okAction)

        present(alertController, animated: true)
    }

    var firstCounter: Counter {
        if let first = counters.first {
            return first
        }

        let first = AppDelegate.repo.addCounter()
        counters.append(first)
        return first
    }

    public func scrollToTheEnd() {
        currentIndex = counters.count - 1
        let viewController = CounterViewController.fromStoryboard(
            for: currentCounter, at: currentIndex)
        pageViewController.setViewControllers(
            [viewController], direction: .forward, animated: true)
    }

    private func setupPageViewController() {
        let viewController = CounterViewController.fromStoryboard(
            for: firstCounter, at: 0)
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
        pageViewController.setViewControllers([viewController],
                                              direction: .forward,
                                              animated: false)
        pageViewController.dataSource = self
        pageViewController.delegate = self

        addChildViewController(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.disableTouchDelay()
        pageViewController.didMove(toParentViewController: self)
    }

    private func disableTouchDelay(inChildrenOf view : UIView) {
        for view in view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delaysContentTouches = false
            }
        }
    }

    private func refreshCounters() {
        counters = AppDelegate.repo.fetchAllCounters()
    }

}

extension RootViewController : UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? CounterViewController else {
            return nil
        }

        let indexBefore = controller.index - 1
        guard indexBefore >= 0, !counters.isEmpty else {
            return nil
        }

        let counterBefore = counters[indexBefore]
        return CounterViewController.fromStoryboard(for: counterBefore, at: indexBefore)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let controller = viewController as? CounterViewController else {
            return nil
        }

        let indexAfter = controller.index + 1
        guard indexAfter < counters.count else {
            return nil
        }

        let counterAfter = counters[indexAfter]
        return CounterViewController.fromStoryboard(for: counterAfter, at: indexAfter)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return counters.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex
    }

}

extension RootViewController : UIPageViewControllerDelegate {

    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        guard completed else {
            return
        }

        if let controller = pageViewController.viewControllers?.first as? CounterViewController {
            currentIndex = controller.index
        }
    }

}

extension UIView {
    func disableTouchDelay() {
        for view in self.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delaysContentTouches = false
            }
        }
    }
}

