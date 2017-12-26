import CoreData

class CounterRepo {

    private var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Klik")
        container.loadPersistentStores() { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()

    private var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func incrementCounter(_ counter: Counter) {
        counter.increment()
        saveContext()
    }

    func setCounterName(_ counter: Counter, name: String) {
        counter.name = name
        saveContext()
    }

    func addCounter() -> Counter {
        let counter = Counter(context: viewContext)
        counter.id = UUID().uuidString
        counter.createdAt = Date()
        saveContext()
        return counter
    }

    func fetchAllCounters() -> [Counter] {
        let request = allCountersFetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    func allCountersFetchRequest() -> NSFetchRequest<Counter> {
        let request: NSFetchRequest<Counter> = Counter.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        return request
    }

}
