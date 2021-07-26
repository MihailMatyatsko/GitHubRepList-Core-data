//  Created by Mihael Matyatsko on 08.07.2021.

import UIKit
import Foundation
import CoreData

extension GitHubOpenReposViewController: UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating{
//MARK: - UI Setup
    func setupUI(){
        tempQueryArrayFromCD = []
        tempReposSourceFromCoreData = []
        searchQueryOne.text = ""
        searchQueryTwo.text = ""
        searchQueryThree.text = ""
        let labelOneTap = UITapGestureRecognizer(target: self, action: #selector(labelOneTapped(sender:)))
        let labelTwoTap = UITapGestureRecognizer(target: self, action: #selector(labelTwoTapped(sender:)))
        let labelThreeTap = UITapGestureRecognizer(target: self, action: #selector(labelThreeTapped(sender:)))
        searchQueryOne.isUserInteractionEnabled = true
        searchQueryOne.addGestureRecognizer(labelOneTap)
        
        searchQueryTwo.isUserInteractionEnabled = true
        searchQueryTwo.addGestureRecognizer(labelTwoTap)
        
        searchQueryThree.isUserInteractionEnabled = true
        searchQueryThree.addGestureRecognizer(labelThreeTap)
    }
//MARK: - History Labels
    @objc func labelOneTapped(sender: UIGestureRecognizer){
        searchControllerForRepos.isActive = true
        searchControllerForRepos.searchBar.text = searchQueryOne.text
        mainViewParametrs(showHistory: false, showTableView: true)
    }
    
    @objc func labelTwoTapped(sender: UIGestureRecognizer){
        searchControllerForRepos.isActive = true
        searchControllerForRepos.searchBar.text = searchQueryTwo.text
        mainViewParametrs(showHistory: false, showTableView: true)
    }
    
    @objc func labelThreeTapped(sender: UIGestureRecognizer){
        searchControllerForRepos.isActive = true
        searchControllerForRepos.searchBar.text = searchQueryThree.text
        mainViewParametrs(showHistory: false, showTableView: true)
    }
//MARK: - Show/Hide history/tableview
    func mainViewParametrs(showHistory: Bool, showTableView: Bool){
        if showHistory == true && showTableView == false{
            //show history
            textInfoLine.isHidden = false
            searchQueryOne.isHidden = false
            searchQueryTwo.isHidden = false
            searchQueryThree.isHidden = false
            // hide table view
            repositoryTableView.isHidden = true
        }
        if showHistory == false && showTableView == true{
            //hide history
            textInfoLine.isHidden = true
            searchQueryOne.isHidden = true
            searchQueryTwo.isHidden = true
            searchQueryThree.isHidden = true
            // show table view
            repositoryTableView.isHidden = false
        }
    }
//MARK: - Tableview repos
    //get htttp adress of certain repository
    func getCellHttpsAdress(identifier: Int){
        var repository : PublicRepositories
        if isSearching{
            repository = filteredRepos[identifier]
        } else {
            repository = reposDataSource[identifier]
        }
        
        GitHubOpenReposViewController.chosenCellurl = repository.html_url
    }
    
// cell register to table view
    func registerCellsForTableViews(){
        repositoryTableView.register(UINib(nibName: "reposTableCell", bundle: nil), forCellReuseIdentifier: mainCellID)
    }
    
// delegate and datasource
    func delegateAndDataSource(){
        //git hub repos table configue
        repositoryTableView.delegate = self
        repositoryTableView.dataSource = self
    }

//number of cells in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if isSearching{
                return filteredRepos.count
            } else {
                return reposDataSource.count
            }
    }

// Main cell configuration
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = repositoryTableView.dequeueReusableCell(withIdentifier: mainCellID, for: indexPath) as? reposTableCell
        
        var repository : PublicRepositories
        if isSearching{
            repository = filteredRepos[indexPath.row]
        } else {
            repository = reposDataSource[indexPath.row]
        }
        
        cell?.reposFullName.text = repository.full_name
        cell?.repositoryDescription.text = repository.description
        cell?.repositoryStars.text = repository.watchers.description
        cell?.reposAvatar.downloadImage(from: repository.owner.avatar_url)
        cell?.html_url_adress = repository.html_url
        
        return cell!
    }
    
// cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
  
// computed footer height in table view
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isSearching{
            return repositoryTableView.bounds.height - (Constants.cellHeight * CGFloat(filteredRepos.count))
        } else {
            return repositoryTableView.bounds.height - (Constants.cellHeight * CGFloat(reposDataSource.count))
        }
    }
    
// selected cell action(redirect)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getCellHttpsAdress(identifier: indexPath.row)
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let DetailWebVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailWeb")
        self.navigationController?.pushViewController(DetailWebVC, animated: true)
    }
    
    //MARK: - SearchController
    func updateSearchResults(for searchController: UISearchController) {
        _ = Timer.scheduledTimer(withTimeInterval: Constants.searchDelay, repeats: false) { _ in
                self.filterContentForSearch(searchController.searchBar.text!)
                if self.searchBarIsEmpty{
                    self.mainViewParametrs(showHistory: true, showTableView: false)
                } else {
                    self.mainViewParametrs(showHistory: false, showTableView: true)
                }
            }
    }
    
    func filterContentForSearch(_ searchText: String){
        if searchText != ""{
            fetchSearchHistoryAndRepositories(predicate: searchText)
            
            if tempReposSourceFromCoreData.count == 0{
                filteredRepos = reposDataSource.filter({ (repository: PublicRepositories) -> Bool in
                    return repository.full_name.lowercased().contains(searchText.lowercased())
                })
                if filteredRepos.count > 0{
                    addSearchHistoryValue(searchText)
                }
                if searchQueryOne.text != searchText && searchQueryTwo.text != searchText && searchQueryThree.text != searchText && filteredRepos.count > 0{
                    addOnlyHistory(searchText)
                }
                DispatchQueue.main.async {
                    self.filteredRepos.sort { $0.watchers > $1.watchers }
                    self.repositoryTableView.reloadData()
                }
            } else {
                filteredRepos.removeAll()
                for i in 0..<tempReposSourceFromCoreData.count{
                    filteredRepos.append(PublicRepositories(id: UInt64(tempReposSourceFromCoreData[i].iD),
                                                            full_name: tempReposSourceFromCoreData[i].fullName!,
                                                            description: tempReposSourceFromCoreData[i].reposDescrip!,
                                                            watchers: UInt64(tempReposSourceFromCoreData[i].watchers),
                                                            html_url: tempReposSourceFromCoreData[i].htmlURL!,
                                                            owner: PRAvatar(avatar_url: tempReposSourceFromCoreData[i].avatarURL!)))
                }
                if searchQueryOne.text != searchText && searchQueryTwo.text != searchText && searchQueryThree.text != searchText{
                    addOnlyHistory(searchText)
                }
                DispatchQueue.main.async {
                    self.filteredRepos.sort { $0.watchers > $1.watchers }
                    self.repositoryTableView.reloadData()
                }
            }
            
        }
    }
    
    func setupSearch(){
        searchControllerForRepos.searchResultsUpdater = self
        searchControllerForRepos.obscuresBackgroundDuringPresentation = false
        
        searchControllerForRepos.searchBar.placeholder = "Enter repository name"
        navigationItem.searchController = searchControllerForRepos
        definesPresentationContext = true
    }
    
    //MARK: - Core Data
    func fetchSearchHistoryAndRepositories(predicate: String){
        do {
            let request = Query.fetchRequest() as NSFetchRequest<Query>
            let pred = NSPredicate(format: "queryText CONTAINS %@", predicate)
            request.predicate = pred
            self.tempQueryArrayFromCD = try context.fetch(request)
            if self.tempQueryArrayFromCD.count > 0 {
                self.tempReposSourceFromCoreData = (self.tempQueryArrayFromCD[0].queryToRes?.allObjects as? [Repositories])!
            } else {
                self.tempReposSourceFromCoreData.removeAll()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addOnlyHistory(_ value: String){
        if searchQueryOne.text == ""{
            searchQueryOne.text = value
            return
        }
        if searchQueryTwo.text == ""{
            searchQueryTwo.text = value
            return
        }
        if searchQueryThree.text == ""{
            searchQueryThree.text = value
            return
        }
        
        if searchQueryOne.text != "" && searchQueryTwo.text != "" && searchQueryThree.text != ""{
            searchQueryThree.text = searchQueryTwo.text
            searchQueryTwo.text = searchQueryOne.text
            searchQueryOne.text = value
            return
        }
    }
    
    func addSearchHistoryValue(_ value: String){
        do {
            var temp = [Query]()
            let request = Query.fetchRequest() as NSFetchRequest<Query>
            let pred = NSPredicate(format: "queryText CONTAINS %@", value)
            request.predicate = pred
            temp = try context.fetch(request)
            if temp.count > 0 {
                return
            }
        } catch {
            print(error.localizedDescription)
        }
        
        let historyQuery = Query(context: context)
        historyQuery.queryText = value
        
        
        for i in 0..<filteredRepos.count{
            let rep = Repositories(context: context)
            rep.iD = Int64(filteredRepos[i].id)
            rep.fullName = filteredRepos[i].full_name
            rep.reposDescrip = filteredRepos[i].description
            rep.watchers = Int64(filteredRepos[i].watchers)
            rep.htmlURL = filteredRepos[i].html_url
            rep.avatarURL = filteredRepos[i].owner.avatar_url
            historyQuery.addToQueryToRes(rep)
        }
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    func deleteAllData(entity: String)
//    {
//        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
//        do {
//            try context.execute(DelAllReqVar)
//        }
//        catch { print(error) }
//    }
}

//MARK: - Image download methods
extension UIImageView{
    
    func verifyUrl (urlString: String?) -> Bool {
        if let url = URL(string: urlString!) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    func downloadImage(from urlLine: String){
        var url: URL?
        if verifyUrl(urlString: urlLine) == true{
            url = URL(string: urlLine)
            URLSession.shared.dataTask(with: url!) { data, response, error in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == Constants.successStatusCode,
                        let data = data, error == nil,
                        let image = UIImage(data: data)
                        else { return }
                    DispatchQueue.main.async() {
                        self.image = image
                    }
                    }.resume()
        } else {
            self.image = UIImage(named: "notFound")!
        }
    }
    
}
