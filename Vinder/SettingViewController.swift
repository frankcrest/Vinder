  //
  //  SettingViewController.swift
  //  Vinder
  //
  //  Created by Frank Chen on 2019-06-20.
  //  Copyright © 2019 Frank Chen. All rights reserved.
  //
  
  import UIKit
  import Photos
  import FirebaseDatabase
  import FirebaseAuth
  
  class SettingViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var ref = Database.database().reference()
    let ud = UserDefaults.standard
    let currentUser = Auth.auth().currentUser
    var uid : String!
    var userInfo : NearbyUser!
    
    
    let backButton : UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let editButton : UIButton = {
        let b = UIButton()
        b.backgroundColor = .green
        b.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let profileHeader : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let imageView : UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let tableView : UITableView = {
        let v = UITableView()
        v.tableFooterView = UIView()
        v.register(SettingTableViewCell.self, forCellReuseIdentifier: "setting")
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupViews()
        uid = currentUser?.uid
    }

    
    func setupViews(){
        self.view.backgroundColor = .yellow
        self.view.addSubview(profileHeader)
        self.profileHeader.addSubview(imageView)
        self.profileHeader.addSubview(editButton)
        self.view.addSubview(backButton)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            
            //back button constraint
            backButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            
            
            //profile pic container constraint
            profileHeader.topAnchor.constraint(equalTo: self.view.topAnchor),
            profileHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            profileHeader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            profileHeader.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -600),
            
            //imageview constraint
            imageView.topAnchor.constraint(equalTo: profileHeader.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: profileHeader.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: profileHeader.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: profileHeader.bottomAnchor),
            
            //editButton constraint
            editButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.widthAnchor.constraint(equalToConstant: 50),
            editButton.trailingAnchor.constraint(equalTo: profileHeader.trailingAnchor, constant: -20),
            editButton.bottomAnchor.constraint(equalTo: profileHeader.bottomAnchor, constant: -20),
            
            //tableView constraint
            tableView.topAnchor.constraint(equalTo: profileHeader.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
    }
    
    
    //handle button tapped
    @objc func backTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func editTapped(){
        let alert = UIAlertController(title: "Choose Photo From", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func changeNameTapped(){
        print("name")
        let indexPath = IndexPath(row: 0, section: 0)
        let alert = UIAlertController(title: "Change Name", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!)-> Void in
            textField.placeholder = "Enter New Display Name"
        })
        let confirm = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {
            UIAlertAction in
            let cell = self.tableView.cellForRow(at: indexPath) as! SettingTableViewCell
            cell.subtitleLabel.text = alert.textFields!.first!.text
            print("OK")
            self.ref.child("users").child(self.uid).updateChildValues(["name": cell.subtitleLabel.text])
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            UIAlertAction in
            print("cancel")
        })
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func changePasswordTapped(){
        print("password")
        let indexPath = IndexPath(row: 1, section: 0)
        let alert = UIAlertController(title: "Change Password", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!)-> Void in
            textField.placeholder = "Enter New Password"
        })
        let confirm = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {
            UIAlertAction in
            let cell = self.tableView.cellForRow(at: indexPath) as! SettingTableViewCell
            cell.subtitleLabel.text = alert.textFields!.first!.text
            print("OK")
//            self.ref.child("users").child(self.uid).updateChildValues(["password": cell.subtitleLabel.text])
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            UIAlertAction in
            print("cancel")
        })
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func changeEmailTapped(){
        let indexPath = IndexPath(row: 2, section: 0)
        let alert = UIAlertController(title: "Change Email", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!)-> Void in
            textField.placeholder = "Enter New Email"
        })
        let confirm = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {
            UIAlertAction in
            let cell = self.tableView.cellForRow(at: indexPath) as! SettingTableViewCell
            cell.subtitleLabel.text = alert.textFields!.first!.text
            print("OK")
            self.ref.child("users").child(self.uid).updateChildValues(["email": cell.subtitleLabel.text])
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            UIAlertAction in
            print("cancel")
        })
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //get image from source type
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var pickedImage : UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            pickedImage = possibleImage
        }else if let possibleImage = info[.originalImage] as? UIImage {
            pickedImage = possibleImage
        } else {
            return
        }
        
        self.imageView.image = pickedImage
        dismiss(animated: true, completion: nil)
    }
    
    
  }
  
  //MARK: TableViewDataSource
  extension SettingViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "setting"
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Display Name"
            cell.subtitleLabel.text = "xxxxxx"
            cell.actionButton.addTarget(self, action: #selector(changeNameTapped), for: .touchUpInside)
        case 1:
            cell.titleLabel.text = "Password"
            cell.subtitleLabel.text = "12345678"
            cell.actionButton.addTarget(self, action: #selector(changePasswordTapped), for: .touchUpInside)
        case 2:
            cell.titleLabel.text = "Email"
            cell.subtitleLabel.text = "xxxxxx@gmail.com"
            cell.actionButton.addTarget(self, action: #selector(changeEmailTapped), for: .touchUpInside)
        default:
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("selected at \(indexPath.row)")
        case 1:
            print("selected at \(indexPath.row)")
            
        case 2:
            print("selected at \(indexPath.row)")
        default:
            print("default selected")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
  }
  
