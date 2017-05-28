import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - Core Data stack

    func applicationWillTerminate(_ application: UIApplication) {
        repo.saveContext()
    }

    // MARK: - Data stack

    var repo: CounterRepo = CounterRepo()

    static var repo: CounterRepo {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.repo
    }

}

