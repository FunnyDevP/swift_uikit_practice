//
//  ViewController.swift
//  placeholder
//
//  Created by Waranchit Chaiwong on 1/14/22.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var users: [User] = []{
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch { resultCompletion in
            switch resultCompletion{
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let users):
                DispatchQueue.main.async {
                    self.users = users
                }
                
            }
        }
        // Do any additional setup after loading the view.
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
    
    func fetch(completion: @escaping (Result<[User],Error>) -> Void){
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                do {
                    let users = try JSONDecoder().decode([User].self, from: data)
                    completion(.success(users))
                } catch let decoderError {
                    completion(.failure(decoderError))
                }
            }
        }.resume()
    }
}

struct User: Decodable {
    var username: String
    var name: String
}

