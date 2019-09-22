//
//  CollectiveRegistrationViewController.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 22/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit
import Cartography

class CollectiveRegistrationViewController: UIViewController {
    var tableView: UITableView!
    let user: User
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        bindStyles()
    }
    
    private func setupViews() {
        tableView = UITableView.init(frame: .zero)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(RegistrationCell.self, forCellReuseIdentifier: RegistrationCell.reusableIdentifier)
        
        tableView.tableFooterView = UIView(frame: .zero)
        
        title = "Opprett kollektiv"
        let saveButton = UIBarButtonItem.init(
            title: "Lagre",
            style: .done,
            target: self,
            action: #selector(createCollective))
        saveButton.tintColor = .black
        navigationItem.rightBarButtonItem = saveButton
        
        view.addSubview(tableView)
    }
    
    private func setupConstraints(){
        constrain(view, tableView) { view, tableView in
            tableView.top == view.top
            tableView.bottom == view.bottom
            tableView.right == view.right
            tableView.left == view.left
        }
    }
    
    private func bindStyles() {
        view.backgroundColor = .white
        
    }
    
    @objc func createCollective(){
        guard let name = (tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! RegistrationCell).userInput.text else {
            print("navn er nil")
            return
        }
        
        guard let address = (tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! RegistrationCell).userInput.text else {
            print("adresse er nil")
            return
        }
        
        let newCollective = Collective.init(name: name, shoppingList: [], inFrigdeList: [], userList: [user], address: address)
        
        AppDelegate.collective = newCollective
        navigationController?.pushViewController(FrontPageViewController.init(), animated: true)
    }
}

extension CollectiveRegistrationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationCell.reusableIdentifier, for: indexPath) as! RegistrationCell
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.informationLabel.text = "Navn:"
            cell.userInput.placeholder = "Mitt kollektiv"
        case 1:
            cell.informationLabel.text = "Adresse:"
            cell.userInput.placeholder = "Drammensveien 1"
        default:
            print("Fant ikke celle")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    
}

