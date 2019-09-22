//
//  RegistrationViewController.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes & Marlen Jarholt on 15/09/2019.
//  Copyright © 2019 Simen Fonnes & Marlen Jarholt. All rights reserved.
//

import UIKit
import Cartography

class UserRegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var tableView: UITableView!
    fileprivate var footerView: FooterView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        bindStyles()
    }
    
    private func setupViews(){
        tableView = UITableView.init(frame: .zero)
        
        
        footerView = FooterView.init(
            frame: CGRect.init(
                x: 0,
                y: 0,
                width: tableView.frame.width,
                height: 200), imageTapped: {
                    self.launchImagePicker()
                    
        })
        
        tableView.register(RegistrationCell.self, forCellReuseIdentifier: RegistrationCell.reusableIdentifier)
        tableView.register(UserDateRegistrationCell.self, forCellReuseIdentifier: UserDateRegistrationCell.reusableIdentifier)
        
        
        
        tableView.tableFooterView = footerView
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        let creatUser = UIBarButtonItem.init(
            title: "Lagre",
            style: .done,
            target: self,
            action: #selector(userCreated))
        creatUser.tintColor = .black
        
        navigationItem.rightBarButtonItem = creatUser
        title = "Opprett bruker"
        
        
        
    }
    
    private func launchImagePicker(){
        let alert = UIAlertController.init(
            title: "Legg til bilde",
            message: nil,
            preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction.init(
            title: "Ta bilde",
            style: .default,
            handler: { [weak self] _ in
                self?.getImage(fromSourceType: .camera)
                }))
        
        alert.addAction(UIAlertAction.init(
            title: "Hent fra bibliotek",
            style: .default,
            handler: { [weak self] _ in
                self?.getImage(fromSourceType: .photoLibrary)
        }))
        
        alert.addAction(UIAlertAction.init(
            title: "Avbryt",
            style: .cancel,
            handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        constrain(view, tableView) { view, tableView in
            tableView.top == view.top
            tableView.bottom == view.bottom
            tableView.right == view.right
            tableView.left == view.left
        }
    }
    
    private func bindStyles(){
        view.backgroundColor = .white
        
    }
    
    // TODO: passordsjekk og feltsjekk
    @objc func userCreated() {
        guard let name = (tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! RegistrationCell).userInput.text else {
            print("Navn er nil")
            return
        }
        guard let eMail = (tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! RegistrationCell).userInput.text else {
            print("epost er nil")
            return
        }
        
        guard let pasword1 = (tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! RegistrationCell).userInput.text else {
            print("passord er nil")
            return
        }
        
        guard let pasword2 = (tableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! RegistrationCell).userInput.text else {
            print("passord er nil")
            return
        }
        
        let birthday = (tableView.cellForRow(at: IndexPath.init(row: 4, section: 0)) as! UserDateRegistrationCell).datePicker.date
        
        let newUser = User.init(
            name: name,
            birthDay: birthday,
            nickname: nil,
            profilePic: footerView.picture.image)
        
        let vc = OnboardCollectiveViewController.init(nibName: nil, bundle: nil, user: newUser)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        footerView.picture.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension UserRegistrationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 4 {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: UserDateRegistrationCell.reusableIdentifier, for: indexPath) as! UserDateRegistrationCell
            dateCell.informationLabel.text = "Fødselsdato:"
            return dateCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationCell.reusableIdentifier, for: indexPath) as! RegistrationCell
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.informationLabel.text = "Navn:"
            cell.userInput.placeholder = "Kari Nordmann"
        case 1:
            cell.informationLabel.text = "E-post:"
            cell.userInput.placeholder = "kari@nordmann.no"
        case 2:
            cell.informationLabel.text = "Passord:"
            cell.userInput.placeholder = "••••••••"
        case 3:
            cell.informationLabel.text = "Passord:"
            cell.userInput.placeholder = "••••••••"
        default:
            print("fant ikke celle")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4{
            return 256
        }
        return 56
    }
    
    
}

fileprivate class FooterView: UIView {
    
    var picture: UIImageView!
    var label: UILabel!
    var containerView: UIView!
    var labelContainerView: UIView!
    let containerViewHeight: CGFloat = 150
    let containerViewWidth: CGFloat = 150
    
    let imageTapped: () -> Void
    
    init(frame: CGRect, imageTapped: @escaping () -> Void) {
        self.imageTapped = imageTapped
        super.init(frame: frame)
        setupViews()
        bindStyles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        containerView = UIView.init(
            frame: CGRect.init(
                x: (UIScreen.main.bounds.width - containerViewWidth) / 2,
                y: (frame.height - containerViewHeight) / 2,
                width: containerViewWidth,
                height: containerViewHeight))
        
        picture = UIImageView.init(
            frame: CGRect.init(
                x: 0,
                y: 0,
                width: containerViewWidth,
                height: containerViewHeight)
        )
        picture.image = UIImage.init(named: "IMG_1700")
        
        labelContainerView = UIView.init(
            frame: CGRect.init(
                x: 0,
                y: containerViewHeight - 40,
                width: containerViewWidth,
                height: 40))
        
        label = UILabel.init(
            frame: CGRect.init(
                x: 0,
                y: 0,
                width: containerViewWidth,
                height: 20))
        
        label.text = "Legg til bilde"
        
        labelContainerView.addSubview(label)
        containerView.addSubview(picture)
        containerView.addSubview(labelContainerView)
        addSubview(containerView)
        
        labelContainerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(pickImageTapped)))
    }
    
    private func bindStyles(){
        containerView.layer.cornerRadius = containerViewHeight / 2
        
        labelContainerView.backgroundColor = Colors.grayTransparent
        label.textColor = .darkGray
        label.textAlignment = .center
        
        containerView.clipsToBounds = true
        
        picture.contentMode = .scaleAspectFill
        picture.clipsToBounds = true
        
    }
    
    @objc func pickImageTapped() {
        imageTapped()
    }
}
