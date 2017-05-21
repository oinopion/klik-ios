import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {
    var pageViewController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
    }

    func counterViewController() -> CounterViewController {
        return storyboard!.instantiateViewController(
            withIdentifier: "CounterViewController") as! CounterViewController

    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                  navigationOrientation: .horizontal,
                                                  options: nil)
        pageViewController.setViewControllers([counterViewController()],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)
        pageViewController.dataSource = self
        
        self.addChildViewController(pageViewController)
        self.disableTouchDelay(inChildrenOf: pageViewController.view)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
    }

    private func disableTouchDelay(inChildrenOf view : UIView) {
        for view in view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delaysContentTouches = false
            }
        }
    }
    
}

extension RootViewController : UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {

        return counterViewController()
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {

        return counterViewController()
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
}



