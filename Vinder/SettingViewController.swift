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
    
    var currentUser : User?
    let imagePicker = UIImagePickerController()
    var ref = Database.database().reference()
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    var playerLayer: AVPlayerLayer!
    var player: AVPlayer!
    var isLoop: Bool = false
    
    let editButton : UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(named:"edit"), for: .normal)
        b.tintColor = UIColor(red: 36/255, green: 171/255, blue: 255/255, alpha: 1)
        b.imageView?.contentMode = .scaleAspectFit
        b.clipsToBounds = true
        b.backgroundColor = .black
        b.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        b.imageEdgeInsets = UIEdgeInsets(top: 8,left: 8,bottom: 8,right: 8)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    let profileHeader : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let profileVideo : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFit
        v.isUserInteractionEnabled = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let imageView : UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .white
        v.isUserInteractionEnabled = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let tableView : UITableView = {
        let v = UITableView()
        v.alwaysBounceVertical = false
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
    }
    
    override func viewDidLayoutSubviews() {
        //Match size of view-controller
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.playerLayer.frame = self.profileVideo.bounds
        CATransaction.commit()
    }
    
    
    func setupViews(){
        self.view.backgroundColor = .yellow
        self.view.addSubview(profileHeader)
        self.profileHeader.addSubview(imageView)
        
        self.view.addSubview(tableView)
        self.view.addSubview(profileVideo)
        
        self.view.addSubview(editButton)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.imageView.addGestureRecognizer(longPressGesture)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        swipeGesture.direction = .down
        self.view.addGestureRecognizer(swipeGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTap))
        self.profileVideo.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            
            //profile pic container constraint
            profileHeader.topAnchor.constraint(equalTo: self.view.topAnchor),
            profileHeader.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            profileHeader.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            profileHeader.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -580),
            
            //imageview constraint
            imageView.topAnchor.constraint(equalTo: profileHeader.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: profileHeader.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: profileHeader.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: profileHeader.bottomAnchor),
            
            //profileVid constraint
//            profileVideo.bottomAnchor.constraint(equalTo: profileHeader.bottomAnchor, constant: -100),
            profileVideo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 80),
            profileVideo.heightAnchor.constraint(equalToConstant: 250),
            profileVideo.widthAnchor.constraint(equalTo: profileVideo.heightAnchor),
            profileVideo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            //editButton constraint
            editButton.heightAnchor.constraint(equalToConstant: 40),
            editButton.widthAnchor.constraint(equalToConstant: 40),
            editButton.trailingAnchor.constraint(equalTo: profileHeader.trailingAnchor, constant: -90),
            editButton.bottomAnchor.constraint(equalTo: profileHeader.bottomAnchor, constant: -20),
            
            //tableView constraint
            tableView.topAnchor.constraint(equalTo: profileHeader.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        setUpProfileVideo()
        self.view.bringSubviewToFront(profileVideo)
        self.view.bringSubviewToFront(editButton)
        profileVideo.layer.cornerRadius = 125
        profileVideo.layer.borderColor = UIColor.white.cgColor
        profileVideo.layer.borderWidth = 5
        
        editButton.layer.cornerRadius = 20
        editButton.layer.borderColor = UIColor.white.cgColor
        editButton.layer.borderWidth = 3.5
        
    }
    
    func setUpProfileVideo(){
        guard let videoURL = currentUser?.profileVideoUrl else { return }
        guard let url = URL(string: videoURL) else { return }
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.profileVideo.frame
        self.profileVideo.layer.addSublayer(playerLayer)
        player.play()
    }
    
    @objc func swipeDown(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func longPress(){
        print("long press")
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
    
    @objc func profileTap(){
        print("tapped")
        self.player.seek(to: CMTime.zero)
        self.player.play()
    }
    
    @objc func editTapped(){
        let recordController = RecordVideoViewController()
        recordController.mode = .profileMode
        self.present(recordController, animated: true, completion: nil)
    }
    
    func changeName(){
        guard let user = currentUser else {return}
        let indexPath = IndexPath(row: 0, section: 0)
        let alert = UIAlertController(title: "Change Name", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!)-> Void in
            textField.placeholder = "Enter New Display Name"
        })
        let confirm = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {
            UIAlertAction in
            let cell = self.tableView.cellForRow(at: indexPath) as! SettingTableViewCell
            guard let alertText = alert.textFields?.first?.text else {return}
            cell.subtitleLabel.text = alertText
            print("OK")
            self.ref.child("users").child(user.uid).updateChildValues(["name": alertText])
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
            UIAlertAction in
            print("cancel")
        })
        alert.addAction(confirm)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func changePassword(){
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
    
    func changeEmail(){
        guard let user = currentUser else {return}
        let indexPath = IndexPath(row: 2, section: 0)
        let alert = UIAlertController(title: "Change Email", message: "", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!)-> Void in
            textField.placeholder = "Enter New Email"
        })
        let confirm = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: {
            UIAlertAction in
            let cell = self.tableView.cellForRow(at: indexPath) as! SettingTableViewCell
            guard let alertText = alert.textFields?.first?.text else {return}
            cell.subtitleLabel.text = alertText
            print("OK")
            self.ref.child("users").child(user.uid).updateChildValues(["email": alertText])
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Account"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView{
            headerView.textLabel?.textColor = UIColor(red: 36/255, green: 171/255, blue: 255/255, alpha: 1)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "setting", for: indexPath) as! SettingTableViewCell
        guard let user = currentUser else {return UITableViewCell()}
        cell.accessoryType = .disclosureIndicator
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "Display Name"
            cell.subtitleLabel.text = user.username
        case 1:
            cell.titleLabel.text = "Password"
            cell.subtitleLabel.text = "12345678"
        case 2:
            cell.titleLabel.text = "Email"
            cell.subtitleLabel.text = user.name
        default:
            return cell
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            changeName()
        case 1:
            changePassword()
        case 2:
            changeEmail()
        default:
            print("default selected")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
  }
  
