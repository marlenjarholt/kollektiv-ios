//
//  ViewController.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes on 07/09/2019.
//  Copyright © 2019 Simen Fonnes. All rights reserved.
//

import UIKit

class FrontPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    var collective: Collective!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collective = makeCollective()
        navigationItem.title = collective.name
        
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        let addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addUser))
        
        addButton.tintColor = .black
        
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addUser(){
        let alert = UIAlertController.init(title: "Legg til bruker", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        
        alert.addAction(UIAlertAction.init(title: "Legg til", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let text = textField?.text
            
            if text != nil && text != "" {
                let newUser = User.init(name: text!)
                self.collective.userList.append(newUser)
                self.tableView.reloadData()
            } else {
                print("Bruker ble ikke laget")
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collective.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init()
        cell.textLabel?.text = collective.userList[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let alert = UIAlertController.init(
                title: "Slette bruker",
                message: "Er du sikker på at du vil slette brukeren?",
                preferredStyle: .actionSheet
            )
            
            alert.addAction(UIAlertAction.init(title: "Slett", style: .destructive, handler: { [weak alert] (_) in
                self.collective.userList.remove(at: indexPath.row)
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Avbryt", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    private func makeCollective() -> Collective {
        let agurk = Item.init(name: "Agurk")
        let tomat = Item.init(name: "Tomat")
        
        let marlen = User.init(name: "Marlen")
        let ingeborg = User.init(name: "Ingeborg")
        let katrine = User.init(name: "Katrine")
        let vibeke = User.init(name: "Vibeke")
        
        let detteKollektivetTrengerEtNavn = Collective.init(
            name: "Dette kollektivet trenger et navn",
            shoppingList: [agurk, tomat],
            inFrigdeList: [],
            userList: [marlen, ingeborg, katrine, vibeke]
        )
        
        return detteKollektivetTrengerEtNavn
    }
}
