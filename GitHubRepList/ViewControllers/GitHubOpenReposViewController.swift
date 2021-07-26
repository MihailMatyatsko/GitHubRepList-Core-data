//  Created by Mihael Matyatsko on 07.07.2021.

import UIKit
import Foundation
import CoreData

class GitHubOpenReposViewController: UIViewController {
//MARK: - Outlets
    @IBOutlet weak var repositoryTableView: UITableView!
    @IBOutlet weak var textInfoLine: UILabel!
    @IBOutlet weak var searchQueryOne: UILabel!
    @IBOutlet weak var searchQueryTwo: UILabel!
    @IBOutlet weak var searchQueryThree: UILabel!
    
    
//MARK: - Variables and Conctants
    //constants
    let mainCellID = "gitCell"
    let networkManager = NetworkManager()
    let searchControllerForRepos = UISearchController(searchResultsController: nil)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //variables
    static var chosenCellurl : String = ""
    var reposDataSource = [PublicRepositories]()
    var filteredRepos = [PublicRepositories]()
    var tempReposSourceFromCoreData = [Repositories]()
    var tempQueryArrayFromCD = [Query]()
    var reposImageDataSource = [UIImage]()
    var isSearching: Bool{
        return searchControllerForRepos.isActive && !searchBarIsEmpty
    }
    var searchBarIsEmpty: Bool{
        guard let searchRequest = searchControllerForRepos.searchBar.text else {
            return false
        }
        return searchRequest.isEmpty
    }
    
    
    //MARK: - Start Up Configure
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "GitHub Reps"
        
        setupUI()
        mainViewParametrs(showHistory: true, showTableView: false)
        registerCellsForTableViews()
        setupSearch()
        delegateAndDataSource()
        networkManager.getRepositories { [weak self] (result) in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let repositories):
                strongSelf.reposDataSource += repositories.items
                strongSelf.reposDataSource.sort{ $0.watchers > $1.watchers }
                DispatchQueue.main.async {
                    strongSelf.repositoryTableView.reloadData()
                }
            case .failure(let error):
                print("Erorr: \(error.localizedDescription)")
            }
        }
        
        
    }
    
}

