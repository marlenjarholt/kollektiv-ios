//
//  ViewController.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 07/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit

class FrontPageViewController: UIViewController{
    
    var tableView: UITableView!
    var collective: Collective
    fileprivate var headerView: HeaderView!
    var addButton: UIBarButtonItem!
    
    init() {
        self.collective = AppDelegate.collective ?? FrontPageViewController.makeCollective()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setInitialValues()
        setupViews()
        bindStyles()
    }
    
    private func setInitialValues(){
        //collective = makeCollective()
        navigationItem.title = "Hjem"
    }
    
    private func setupViews(){
        tableView = UITableView.init(
            frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),
            style: .grouped
        )
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addUser))
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(tableView)
        addHeaderView()
    }
    
    private func bindStyles(){
        tableView.backgroundColor = .clear
        addButton.tintColor = .black
    }
    
    private func addHeaderView(){
        headerView = HeaderView.init(
            frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100))
        tableView.tableHeaderView = headerView
        headerView.nameLabel.text = collective.name
        headerView.addressLabel.text = collective.address
    }
    
    @objc func addUser(){
        let alert = UIAlertController.init(title: "Legg til bruker", message: nil, preferredStyle: .alert)
        
        alert.addTextField()
        
        alert.addAction(UIAlertAction.init(title: "Legg til", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            let text = textField?.text
            
            if text != nil && text != "" {
                let newUser = User.init(name: text!, birthDay: Date(), nickname: nil, profilePic: nil)
                self.collective.userList.append(newUser)
                self.tableView.reloadData()
            } else {
                print("Bruker ble ikke laget")
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }

    static func makeCollective() -> Collective {
        let agurk = Item.init(name: "Agurk")
        let tomat = Item.init(name: "Tomat")
        
        let marlen = User.init(name: "Marlen", birthDay: marlenDate()!, nickname: nil, profilePic: UIImage.init(named: "IMG_1700"))
        let ingeborg = User.init(name: "Ingeborg", birthDay: Date(), nickname: nil, profilePic: nil)
        let katrine = User.init(name: "Katrine", birthDay: Date(), nickname: nil, profilePic: nil)
        let vibeke = User.init(name: "Vibeke", birthDay: Date(), nickname: nil, profilePic: nil)
        
        let detteKollektivetTrengerEtNavn = Collective.init(
            name: "Dette kollektivet trenger et navn",
            shoppingList: [agurk, tomat],
            inFrigdeList: [],
            userList: [marlen, ingeborg, katrine, vibeke],
            address: "Gamle Madserud Allé 8"
        )
        
        return detteKollektivetTrengerEtNavn
    }
    
    static func marlenDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let someDateTime = formatter.date(from: "1998/03/26 08:10")
        return someDateTime
    }
}

extension FrontPageViewController: UITableViewDelegate, UITableViewDataSource{
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
            
            alert.addAction(UIAlertAction.init(title: "Slett", style: .destructive, handler: { _ in
                self.collective.userList.remove(at: indexPath.row)
                self.tableView.reloadData()
            }))
            
            alert.addAction(UIAlertAction.init(title: "Avbryt", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = collective.userList[indexPath.row]
        let userViewController = UserViewController.init(user: user, nibName: nil, bundle: nil)
        
        let backButton = UIBarButtonItem.init()
        backButton.title = "Tilbake"
        backButton.tintColor = .black
        navigationItem.backBarButtonItem = backButton
        
        userViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(userViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerView = UIView.init(frame: CGRect.init(x: 0, y: 100, width: tableView.frame.width, height: 56))
        containerView.backgroundColor = Colors.mainColor
        
        let sectionLabel = UILabel.init(frame: CGRect.init(x: 16, y: 18, width: tableView.frame.width - 32, height: 44))
        sectionLabel.text = "Beboere"
        sectionLabel.font = UIFont.boldSystemFont(ofSize: 28)
        
        
        containerView.addSubview(sectionLabel)
        
        return containerView
        
    }
}


fileprivate class HeaderView: UIView{
    
    var nameLabel: UILabel!
    var addressLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        bindStyles()
    }
    
    private func setupViews(){
        let width: CGFloat = UIScreen.main.bounds.width - 32
        let height: CGFloat = 24
        let leftPadding: CGFloat = 16
        
        nameLabel = UILabel.init(
            frame: CGRect.init(x: leftPadding, y: 16, width: width, height: height))
        addressLabel = UILabel.init(frame: CGRect.init(x: leftPadding, y: 56, width: width, height: height))
        
        addSubview(nameLabel)
        addSubview(addressLabel)
    }
    
    private func bindStyles(){
        nameLabel.textAlignment = .center
        addressLabel.textAlignment = .center
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: nameLabel.font.pointSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
