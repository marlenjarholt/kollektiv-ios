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
    fileprivate var validationAlert: ValidationAlert!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        bindStyles()
    }
    
    private func setupViews() {
        tableView = UITableView.init(frame: .zero)
        validationAlert = ValidationAlert.init(frame: .zero)

        footerView = FooterView.init(
            frame: CGRect.init(
                x: 0,
                y: 0,
                width: tableView.frame.width,
                height: 200),
            imageTapped: { self.launchImagePicker() }
        )
        
        tableView.register(RegistrationCell.self, forCellReuseIdentifier: RegistrationCell.reusableIdentifier)
        tableView.register(UserDateRegistrationCell.self, forCellReuseIdentifier: UserDateRegistrationCell.reusableIdentifier)
        tableView.tableFooterView = footerView
        tableView.delegate = self
        tableView.dataSource = self
        
        let creatUser = UIBarButtonItem.init(
            title: "Lagre",
            style: .done,
            target: self,
            action: #selector(userCreated)
        )
        creatUser.tintColor = .black
        
        navigationItem.rightBarButtonItem = creatUser
        title = "Opprett bruker"

        view.addSubview(tableView)
        view.addSubview(validationAlert)
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
        constrain(view, tableView, validationAlert) { view, tableView, validationAlert in
            tableView.top == view.top
            tableView.bottom == view.bottom
            tableView.right == view.right
            tableView.left == view.left

            validationAlert.bottom == view.bottom
            validationAlert.right == view.right
            validationAlert.left == view.left
            validationAlert.height == 100
        }
    }
    
    private func bindStyles(){
        view.backgroundColor = .white
        validationAlert.isHidden = true
    }

    @objc func userCreated() {
        let name = (tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! RegistrationCell).userInput.text
        let eMail = (tableView.cellForRow(at: IndexPath.init(row: 1, section: 0)) as! RegistrationCell).userInput.text
        let password1 = (tableView.cellForRow(at: IndexPath.init(row: 2, section: 0)) as! RegistrationCell).userInput.text
        let password2 = (tableView.cellForRow(at: IndexPath.init(row: 3, section: 0)) as! RegistrationCell).userInput.text
        let birthday = (tableView.cellForRow(at: IndexPath.init(row: 4, section: 0)) as! UserDateRegistrationCell).datePicker.date

        if !validateUser(name: name, email: eMail, password1: password1, password2: password2) {
            validationAlert.isHidden = false
            return
        }

        validationAlert.isHidden = true
        
        let newUser = User.init(
            name: name!,
            birthDay: birthday,
            nickname: nil,
            profilePic: footerView.picture.image)

        
        let vc = OnboardCollectiveViewController.init(nibName: nil, bundle: nil, user: newUser)
        
        navigationController?.pushViewController(vc, animated: true)
    }

    func validateUser(name: String?, email: String?, password1: String?, password2: String?) -> Bool {
        var isValid = true
        var bothPasswordsValid = true

        var errors = [String]()
        if !validateName(name: name) {
            errors.append("Ugyldig navn: må ha fornavn og etternavn")
            isValid = false
        }

        if !validateEmail(email: email) {
            errors.append("Ugyldig epost")
            isValid = false
        }

        if !validatePassword(password: password1) {
            errors.append("Første passord ugyldig: Må være mellom 8 og 24 tegn")
            isValid = false
            bothPasswordsValid = false
        }

        if !validatePassword(password: password2) {
            errors.append("Andre passord ugyldig: Må være mellom 8 og 24 tegn")
            isValid = false
            bothPasswordsValid = false
        }

        if bothPasswordsValid {
            if !validateEqualPasswords(password1: password1!, password2: password2!) {
                errors.append("Passordene må være like")
                isValid = false
            }
        }


        //passord1 og 2 må matche min 8, max 24
        validationAlert.setDescripion(errors: errors)
        return isValid
    }

    /// name must not be nil, min two words
    private func validateName(name: String?) -> Bool {
        guard let name = name else { return false }
        return name.split(separator: " ").count > 1
    }

    /// email can´t be nil and not valid
    private func validateEmail(email: String?) -> Bool {
        guard let email = email else { return false }
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    ///password is min 8 and max 24
    private func validatePassword(password: String?) -> Bool {
        guard let password = password else { return false }
        return 8 ... 24 ~= password.count
    }

    ///passwords must be equal
    private func validateEqualPasswords(password1: String, password2: String) -> Bool {
        return password1 == password2
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
            cell.userInput.autocapitalizationType = .words
        case 1:
            cell.informationLabel.text = "E-post:"
            cell.userInput.placeholder = "kari@nordmann.no"
            cell.userInput.keyboardType = .emailAddress
            cell.userInput.autocapitalizationType = .none
        case 2:
            cell.informationLabel.text = "Passord:"
            cell.userInput.placeholder = "••••••••"
            cell.userInput.isSecureTextEntry = true
            cell.userInput.autocapitalizationType = .none
        case 3:
            cell.informationLabel.text = "Passord:"
            cell.userInput.placeholder = "••••••••"
            cell.userInput.isSecureTextEntry = true
            cell.userInput.autocapitalizationType = .none
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

fileprivate class ValidationAlert: UIView {

    var titleLabel: UILabel!
    var descriptionTextView: UITextView!

    init(frame: CGRect, description: String? = nil) {
        super.init(frame: frame)

        setupViews()
        setupConstrains()
        bindStyles()
        titleLabel.text = "Noe gikk galt"
        descriptionTextView.text = description
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        titleLabel = UILabel.init(frame: .zero)
        descriptionTextView = UITextView.init(frame: .zero)
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = false

        addSubview(titleLabel)
        addSubview(descriptionTextView)
    }

    private func setupConstrains() {
        constrain(self, titleLabel, descriptionTextView) { view, titleLabel, descriptionTextView in
            let padding: CGFloat = 16
            titleLabel.left == view.left + padding
            titleLabel.right == view.right - padding
            titleLabel.top == view.top + padding

            descriptionTextView.top == titleLabel.bottom
            descriptionTextView.left == view.left + padding
            descriptionTextView.right == view.right - padding
            descriptionTextView.bottom == view.bottom - padding
        }
    }

    private func bindStyles() {
        backgroundColor = Colors.alertColor

        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        descriptionTextView.textColor = .white
        descriptionTextView.backgroundColor = .clear
    }

    func setDescripion(errors: [String]) {
        let description = errors.map { "• \($0)\n" }
            .reduce ("", { prev, next in
                prev + next
            })
        descriptionTextView.text = description
    }
}
