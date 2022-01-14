//
//  ViewController.swift
//  placeholder
//
//  Created by Waranchit Chaiwong on 1/14/22.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var apiManager: APIManager?
    var users: [User] = []{
        didSet {
            tableView.reloadData()
        }
    }
    
    func setupApiManager(){
        apiManager = APIManager()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupApiManager()
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")
        apiManager?.fetchItems(url: url!, completion: { (resultCompletion: Result<[User],Error>) in
            switch resultCompletion {
            case .success(let users):
                DispatchQueue.main.async {
                    self.users = users
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeView", for: indexPath)
        
        let user = users[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = user.username
        content.secondaryText = user.name
        
        cell.contentConfiguration = content
        
        return cell
    }
}

struct User: Decodable {
    var username: String
    var name: String
}

