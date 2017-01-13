//
//  ViewController.swift
//  CoreDataGenerics
//
//  Created by Ievgen Keba on 1/12/17.
//  Copyright © 2017 Harman Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let userController: DataControllerProtocol = DataController()
    // Switch between two implementations of DataVariety
    //let userController: UserDataControllerProtocol = DataControllerVariety()
    
    let nameTF: UITextField = UITextField()
    let usernameTF: UITextField = UITextField()
    let loadBtn: UIButton = UIButton(type: UIButtonType.system)
    let updateBtn: UIButton = UIButton(type: UIButtonType.system)
    let clearBtn: UIButton = UIButton(type: UIButtonType.system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(textField: nameTF, with: "name")
        configure(textField: usernameTF, with: "username")
        configure(button: loadBtn, with: "Load", and: #selector(loadPressed))
        configure(button: updateBtn, with: "Update", and: #selector(updatePressed))
        configure(button: clearBtn, with: "Clear", and: #selector(clearPressed))
        
        view.addSubview(nameTF)
        view.addSubview(usernameTF)
        view.addSubview(loadBtn)
        view.addSubview(updateBtn)
        view.addSubview(clearBtn)
        
        setupConstraints()
        loadUser()
    }
    
    private func configure(textField: UITextField, with placeholder: String? = nil){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 5.0
        textField.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    private func configure(button: UIButton, with title: String, and action: Selector){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    private func setupConstraints(){
        
        nameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTF.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 100.0).isActive = true
        
        usernameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameTF.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 20.0).isActive = true
        
        updateBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateBtn.topAnchor.constraint(equalTo: usernameTF.bottomAnchor, constant: 20.0).isActive = true
        
        loadBtn.trailingAnchor.constraint(equalTo: updateBtn.leadingAnchor, constant: -20).isActive = true
        loadBtn.topAnchor.constraint(equalTo: updateBtn.topAnchor).isActive = true
        
        clearBtn.leadingAnchor.constraint(equalTo: updateBtn.trailingAnchor, constant: 20).isActive = true
        clearBtn.topAnchor.constraint(equalTo: updateBtn.topAnchor).isActive = true
    }
    
    private func loadUser(){
        userController.fetchUser { (user) in
            guard let user = user else { return }
            self.nameTF.text = user.name
            self.usernameTF.text = user.username
        }
    }
    @objc private func updatePressed(){
        userController.updateUser(name: nameTF.text ?? "", username: usernameTF.text ?? "")
    }
    @objc private func loadPressed(){
        loadUser()
    }
    @objc private func clearPressed(){
        nameTF.text = nil
        usernameTF.text = nil
    }
}

