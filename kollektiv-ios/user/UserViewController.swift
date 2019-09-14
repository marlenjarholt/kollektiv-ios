//
//  UserViewController.swift
//  kollektiv-ios
//
//  Created by Simen Fonnes on 08/09/2019.
//  Copyright © 2019 Simen Fonnes. All rights reserved.
//

import UIKit

class UserViewController: UIViewController{
    var user: User
    
    var imageView: UIImageView!
    var ageLabel: UILabel!
    
    let imageSize:CGFloat = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red:0.63, green:1.00, blue:0.87, alpha:1.0)
        title = user.name
        navigationController?.navigationBar.barTintColor = .white
        
        imageView = UIImageView.init(
            frame: CGRect.init(x: 16, y: 128, width: imageSize, height: imageSize)
        )
        imageView.image = user.profilePic
        //imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = imageSize / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0

        
        view.addSubview(imageView)
        
        ageLabel = UILabel.init(frame: CGRect.init(x: 232, y: 128, width: 200, height: 50))
        ageLabel.text = "\(user.age())"
        view.addSubview(ageLabel)
    }
    
    init(user: User, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.user = user
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toParent parent: UIViewController?) {
        parent?.navigationController?.navigationBar.barTintColor = UIColor(red:0.63, green:1.00, blue:0.87, alpha:1.0)
    }
}
