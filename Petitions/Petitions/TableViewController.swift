//
//  TableViewController.swift
//  Petitions
//
//  Created on 9.10.22.
//

import UIKit

class TableViewController: UITableViewController {
    var petitions = [Petition]()
    var allPetitions = [Petition]()
    var filterPhase: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Petitions"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterPetitions))
        
        let urlString: String
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                
                for item in petitions {
                    allPetitions.append(item)
                }
                return
            }
        }
        showError()
    }
    
    @objc func filterPetitions() {
        filterPhase = ""
        
        let ac = UIAlertController(title: "Filter petitions", message: "Type your word(phase) below", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Filter", style: .default) { [weak self, weak ac] _ in
            guard let text = ac?.textFields?[0].text else { return }
            self?.filterPhase = text
            self?.displayFiltered()
        })
        present(ac, animated: true)
    }
    
    func displayFiltered() {
        petitions = []
        
        if let filterPhase = filterPhase {
            for petition in allPetitions {
                if petition.body.contains(filterPhase) || petition.title.contains(filterPhase) {
                    petitions.append(petition)
                }
            }
        }
        tableView.reloadData()
    }
    
    @objc func showCredits() {
        let ac = UIAlertController(title: "Credits", message: "The data comes from the We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "Check connection", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = petitions[indexPath.row].title
        cell.detailTextLabel?.text = petitions[indexPath.row].body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vs = DetailViewController()
        //vs.modalPresentationStyle = .fullScreen
        vs.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vs, animated: true)
    }


}

