import UIKit
import CoreLocation
import MapKit
import Firebase

//78 178 249 blue color hex code
class MapViewController: UIViewController {
    
    //MARK: PROPERTIES
    private let webService = WebService()
    private var messages: [Messages] = []
    let ref = Database.database().reference()
    var currentUser = Auth.auth().currentUser
    var selfUser : User?
    var locationManager:CLLocationManager = CLLocationManager()
    var userLocations = [UserLocation]()
    var userLocation : CLLocation? {
        didSet{
            updateLocationToFirebase()
        }
    }
    
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    var leftViewTrailing :NSLayoutConstraint!
    var rightViewLeading: NSLayoutConstraint!
    var users : [User] = []
    let maleColor : UIColor = UIColor(red: 98, green: 98, blue: 247, alpha: 1)
    let femaleColor : UIColor = UIColor(red: 255, green: 166, blue: 236, alpha: 1)
    var selectedUser: User?
    var swipeRecog = UISwipeGestureRecognizer()
    var friendList = [String]()
    var friends = [User]()
    //MARK: VIEW PROPERTIES
    
    let videoView : VideoView = {
        let v = VideoView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 10
        v.clipsToBounds = true
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let buttonContainer:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    let navView: GradientView = {
        let v = GradientView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let navViewLeft: UIView = {
        let v = UIView()
        v.isUserInteractionEnabled = true
        v.backgroundColor = .magenta
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let navViewRight: UIView = {
        let v = UIView()
        v.backgroundColor = .cyan
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let mapView : MKMapView = {
        let mp = MKMapView()
        mp.mapType = MKMapType.standard
        mp.isZoomEnabled = true
        mp.isScrollEnabled = true
        mp.showsUserLocation = false
        mp.showsCompass = false
        mp.translatesAutoresizingMaskIntoConstraints = false
        return mp
    }()
    
    let logoutButton: UIButton = {
        let b = UIButton()
        b.setTitle("logout", for: .normal)
        b.backgroundColor = .cyan
        b.setTitleColor(.black, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        b.layer.cornerRadius = 25
        return b
    }()
    
    let settingButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .clear
        b.setImage(UIImage(named:"settings"), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 25
        b.addTarget(self, action: #selector(settingTapped), for: .touchUpInside)
        return b
    }()
    
    let refreshButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .clear
        b.setImage(UIImage(named:"refresh"), for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.layer.cornerRadius = 25
        b.addTarget(self, action: #selector(refreshTapped), for: .touchUpInside)
        return b
    }()
    
    let contactButton: RoundedButton = {
        let b = RoundedButton()
        //        b.backgroundColor = .magenta
        b.addTarget(self, action: #selector(contactTapped), for: .touchUpInside)
        b.setImage(UIImage(named: "friends"), for: .normal)
        return b
    }()
    
    let mapButton: RoundedButton = {
        let b = RoundedButton()
        //        b.backgroundColor = .green
        b.addTarget(self, action: #selector(mapTapped), for: .touchUpInside)
        b.setImage(UIImage(named: "map"), for: .normal)
        return b
    }()
    
    let messagesButton: RoundedButton = {
        let b = RoundedButton()
        //        b.backgroundColor = .cyan
        b.addTarget(self, action: #selector(meTapped), for: .touchUpInside)
        b.setImage(UIImage(named:"messages"), for: .normal)
        return b
    }()
    
    let finderButton: RoundedButton = {
        let b = RoundedButton()
        b.addTarget(self, action: #selector(focusOneUser), for: .touchUpInside)
        b.setImage(UIImage(named: "finder"), for: .normal)
        return b
    }()
    
    let buttonStackView:UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .center
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let messageTableView:UITableView = {
        let tb = UITableView()
        tb.separatorStyle = .none
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.backgroundColor = .white
        tb.register(MessageTableViewCell.self, forCellReuseIdentifier: "messageCell")
        return tb
    }()
    
    let contactsCollectionView:UICollectionView = {
        let flowLayout = CustomFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(ContactsCollectionViewCell.self, forCellWithReuseIdentifier: "contactCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let centerView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let leftView: UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let rightView: UIView = {
        let v = UIView()
        v.backgroundColor = .yellow
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let inboxLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Inbox"
        l.font = UIFont.systemFont(ofSize: 35, weight: .semibold)
        l.textColor = .white
        return l
    }()
    
    let favoriteLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Favorites"
        l.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        l.textColor = .white
        return l
    }()
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    var focusedUserIndex = 0
    
    //MARK: SET CONSTRAINTS PROPERTY
    var buttonStackViewTrailingConstraint: NSLayoutConstraint?
    var buttonStackViewLeadingConstraint: NSLayoutConstraint?
    var mapButtonWidthCons: NSLayoutConstraint?
    var mapButtonHeightCons: NSLayoutConstraint?
    var messageButtonWidthCons: NSLayoutConstraint?
    var messageButtonHeightCons: NSLayoutConstraint?
    var contactButtonWidthCons: NSLayoutConstraint?
    var contactButtonHeightCons: NSLayoutConstraint?
    
    
    
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        webService.updateProgressDelegate = videoView
        mapView.register(NearbyUserView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        setupViews()
        
        retrieveFriendList { (list) in
            self.retrieveFriendsData(friendList: list)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            presentLogInNavigationController()
        } else{
            currentUser = Auth.auth().currentUser
            determineCurrentLocation()
            getMessages()
            loadUsers()
        }
        view.layoutSubviews()
        generator.prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        ref.child("users").removeAllObservers()
        if !videoView.isHidden {
            hideVideoView()
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    
    
    private func presentLogInNavigationController() {
        let loginNav = UINavigationController()
        loginNav.viewControllers = [LoginViewController()]
        loginNav.modalPresentationStyle = .fullScreen
        present(loginNav, animated: false, completion: nil)
    }
    
    //MARK: SETUP VIEWS
    func setupViews(){
        self.view.addSubview(centerView)
        self.view.addSubview(leftView)
        self.view.addSubview(rightView)
        
        self.centerView.addSubview(mapView)
        self.mapView.addSubview(navView)
        self.centerView.addSubview(logoutButton)
        self.navView.addSubview(settingButton)
        self.centerView.addSubview(refreshButton)
        self.view.addSubview(buttonStackView)
        self.buttonStackView.addArrangedSubview(contactButton)
        self.buttonStackView.addArrangedSubview(mapButton)
        self.buttonStackView.addArrangedSubview(messagesButton)
        
        self.rightView.addSubview(messageTableView)
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        self.leftView.addSubview(contactsCollectionView)
        contactsCollectionView.delegate = self
        contactsCollectionView.dataSource = self
        
        self.view.addSubview(videoView)
        
        self.leftView.addSubview(navViewLeft)
        self.rightView.addSubview(navViewRight)
        navViewRight.addSubview(inboxLabel)
        navViewLeft.addSubview(favoriteLabel)
        self.view.insertSubview(finderButton, aboveSubview: mapView)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        
        videoView.rightButton.setImage(UIImage(named: "call"), for: .normal)
        videoView.leftButton.setImage(UIImage(named: "message"), for: .normal)
        videoView.heartButton.setImage(UIImage(named:"like"), for: .normal)
        
        videoView.leftButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        videoView.heartButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)
        videoView.rightButton.addTarget(self, action: #selector(callTapped), for: .touchUpInside)
        videoView.addGestureRecognizer(swipeRecog)
        swipeRecog.addTarget(self, action: #selector(swipeHandler(_:)))
        swipeRecog.direction = .up
        
        leftViewTrailing = leftView.trailingAnchor.constraint(equalTo: self.centerView.leadingAnchor, constant: 0)
        rightViewLeading = rightView.leadingAnchor.constraint(equalTo: self.centerView.trailingAnchor, constant: 0)
        
        buttonStackViewTrailingConstraint = buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30)
        buttonStackViewLeadingConstraint = buttonStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30)
        mapButtonWidthCons =  mapButton.widthAnchor.constraint(equalToConstant: 70)
        mapButtonHeightCons =  mapButton.heightAnchor.constraint(equalToConstant: 70)
        messageButtonHeightCons = messagesButton.heightAnchor.constraint(equalToConstant: 55)
        messageButtonWidthCons = messagesButton.widthAnchor.constraint(equalToConstant: 55)
        contactButtonHeightCons = contactButton.heightAnchor.constraint(equalToConstant: 55)
        contactButtonWidthCons = contactButton.widthAnchor.constraint(equalToConstant: 55)
        
        
        NSLayoutConstraint.activate([
            
            inboxLabel.centerXAnchor.constraint(equalTo: navViewRight.centerXAnchor),
            inboxLabel.centerYAnchor.constraint(equalTo: navViewRight.centerYAnchor, constant: 15),
            
            favoriteLabel.centerXAnchor.constraint(equalTo: navViewLeft.centerXAnchor),
            favoriteLabel.centerYAnchor.constraint(equalTo: navViewLeft.centerYAnchor, constant: 15),
            
            navView.topAnchor.constraint(equalTo: self.mapView.topAnchor, constant: 0),
            navView.leadingAnchor.constraint(equalTo: self.mapView.leadingAnchor, constant: 0),
            navView.trailingAnchor.constraint(equalTo: self.mapView.trailingAnchor, constant: 0),
            navView.heightAnchor.constraint(equalToConstant: 180),
            
            centerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            centerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            centerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            centerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            
            leftViewTrailing,
            leftView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            leftView.heightAnchor.constraint(equalToConstant: self.view.bounds.height),
            leftView.widthAnchor.constraint(equalToConstant: self.view.bounds.width),
            
            rightViewLeading,
            rightView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            rightView.heightAnchor.constraint(equalToConstant: self.view.bounds.height),
            rightView.widthAnchor.constraint(equalToConstant: self.view.bounds.width),
            
            navViewLeft.topAnchor.constraint(equalTo: self.leftView.topAnchor, constant: 0),
            navViewLeft.leadingAnchor.constraint(equalTo: self.leftView.leadingAnchor, constant: 0),
            navViewLeft.trailingAnchor.constraint(equalTo: self.leftView.trailingAnchor, constant: 0),
            navViewLeft.heightAnchor.constraint(equalToConstant: 100),
            
            navViewRight.topAnchor.constraint(equalTo: self.rightView.topAnchor, constant: 0),
            navViewRight.leadingAnchor.constraint(equalTo: self.rightView.leadingAnchor, constant: 0),
            navViewRight.trailingAnchor.constraint(equalTo: self.rightView.trailingAnchor, constant: 0),
            navViewRight.heightAnchor.constraint(equalToConstant: 100),
            
            mapView.topAnchor.constraint(equalTo: self.centerView.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: self.centerView.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: self.centerView.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: self.centerView.bottomAnchor, constant: 0),
            
            logoutButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: statusBarHeight),
            logoutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.widthAnchor.constraint(equalToConstant: 50),
            
            settingButton.topAnchor.constraint(equalTo: self.navView.topAnchor, constant: statusBarHeight),
            settingButton.trailingAnchor.constraint(equalTo: self.navView.trailingAnchor, constant: -10),
            settingButton.heightAnchor.constraint(equalToConstant: 50),
            settingButton.widthAnchor.constraint(equalToConstant: 50),
            
            contactButtonWidthCons!,
            contactButtonHeightCons!,
            
            mapButtonHeightCons!,
            mapButtonWidthCons!,
            
            messageButtonHeightCons!,
            messageButtonWidthCons!,
            
            
            finderButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finderButton.heightAnchor.constraint(equalToConstant: 40),
            finderButton.widthAnchor.constraint(equalToConstant: 40),
            finderButton.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -20),
            
            buttonStackViewLeadingConstraint!,
            buttonStackViewTrailingConstraint!,
            buttonStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStackView.heightAnchor.constraint(equalToConstant: 75),
            
            refreshButton.bottomAnchor.constraint(equalTo: self.buttonStackView.topAnchor, constant: -10),
            refreshButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            refreshButton.heightAnchor.constraint(equalToConstant: 50),
            refreshButton.widthAnchor.constraint(equalToConstant: 50),
            
            messageTableView.topAnchor.constraint(equalTo: self.navViewRight.bottomAnchor, constant: 0),
            messageTableView.leadingAnchor.constraint(equalTo: self.rightView.leadingAnchor, constant: 0),
            messageTableView.trailingAnchor.constraint(equalTo: self.rightView.trailingAnchor, constant: 0),
            messageTableView.bottomAnchor.constraint(equalTo: self.rightView.bottomAnchor, constant: 0),
            
            contactsCollectionView.topAnchor.constraint(equalTo: self.navViewLeft.bottomAnchor, constant: 0),
            contactsCollectionView.leadingAnchor.constraint(equalTo: self.leftView.leadingAnchor, constant: 0),
            contactsCollectionView.trailingAnchor.constraint(equalTo: self.leftView.trailingAnchor, constant: 0),
            contactsCollectionView.bottomAnchor.constraint(equalTo: self.leftView.bottomAnchor, constant: 0),
            
            //            videoView.topAnchor.constraint(equalTo: self.centerView.topAnchor, constant: statusBarHeight + 58),
            //            videoView.leadingAnchor.constraint(equalTo: self.centerView.leadingAnchor, constant: 50),
            //            videoView.trailingAnchor.constraint(equalTo: self.centerView.trailingAnchor ,constant: -50),
            //            videoView.bottomAnchor.constraint(equalTo: self.centerView.bottomAnchor, constant: -180),
            
            videoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            videoView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            videoView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 3.0/4.0),
            videoView.heightAnchor.constraint(equalTo: view.widthAnchor),
            ])
        
    }
    
    //MARK: LOAD USER AND LOCATE
    func determineCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
        }
    }
    
    func loadUsers(){
        print("fetching users")
        mapView.removeAnnotations(users)
        users.removeAll()
        webService.fetchUsers { (users) in
            guard let users = users else {
                print("failed fetching users")
                return
            }
            for user in users {
                if user.uid == self.currentUser?.uid{
                    self.selfUser = user
                }
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(user)
                }
                self.users.append(user)
            }
        }
    }
    
    func loadUserLocations(){
        ref.child("userLocation").observe(.childChanged) { (snapshot) in
            for location in snapshot.children.allObjects as! [DataSnapshot]{
                guard let locationObject = location.value as? [String:AnyObject] else {return}
                
                let uid = location.key
                guard let lat = locationObject["latitude"] as? String else {return}
                guard let lon = locationObject["longitude"] as? String else {return}
                
                let location = UserLocation(uid: uid, lat: lat, long: lon)
                self.userLocations.append(location)
            }
        }
    }
    
    //MARK: FETCH MESSAGE
    
    func getMessages() {
        
        self.webService.fetchAllMessages { (allMessages) -> (Void) in
            
            guard let allMessages = allMessages else { return }
            DispatchQueue.main.async {
                self.messages = allMessages
                self.messages.sort { (msg1, msg2) -> Bool in
                    return msg1.timestamp > msg2.timestamp
                }
                self.messageTableView.reloadData()
            }
        }
    }
    
    
    func updateLocationToFirebase(){
        guard let location = userLocation else{return}
        let lat = String(format: "%f", location.coordinate.latitude)
        let lon = String(format: "%f", location.coordinate.longitude)
        guard let user = currentUser else {return}
        print("uid: \(user.uid)")
        webService.updateUserWithLocation(lat: lat, lon: lon, uid: user.uid)
        //??????????????????????????
        loadUsers()
    }
    
    //MARK: BUTTON ACTIONS
    @objc func logoutTapped(){
        videoView.isHidden = true
        do{
            try webService.logOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            presentLogInNavigationController()
            
        }catch let err{
            print("can not log out \(err)")
        }
    }
    
    @objc func settingTapped(){
        let settingsVC = SettingViewController()
        guard let user = selfUser else {return}
        settingsVC.currentUser = user
        self.present(settingsVC, animated: true, completion: nil)
    }
    
    @objc func contactTapped(){
        generator.impactOccurred()
        buttonStackViewTrailingConstraint?.constant = -100
        buttonStackViewLeadingConstraint?.constant = 100
        messageButtonWidthCons?.constant = 35
        messageButtonHeightCons?.constant = 35
        mapButtonWidthCons?.constant = 35
        mapButtonHeightCons?.constant = 35
        contactButtonHeightCons?.constant = 70
        contactButtonWidthCons?.constant = 70
        showAllanotations()
        finderButton.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        if !videoView.isHidden {
            hideVideoView()
        }
        if rightViewLeading.constant == -self.view.bounds.width {
            
            UIView.animate(withDuration: 0.2, delay: 0, options:.curveEaseOut, animations: {
                self.rightViewLeading.constant = 0
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.3, delay: 0, options:.curveEaseIn, animations: {
                self.leftViewTrailing.constant = self.view.bounds.width
                self.view.layoutIfNeeded()
            })
            
        } else{
            leftViewTrailing.constant = self.view.bounds.width
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func mapTapped(){
        generator.impactOccurred()
        buttonStackViewTrailingConstraint?.constant = -30
        buttonStackViewLeadingConstraint?.constant = 30
        messageButtonWidthCons?.constant = 55
        messageButtonHeightCons?.constant = 55
        mapButtonWidthCons?.constant = 70
        mapButtonHeightCons?.constant = 70
        contactButtonHeightCons?.constant = 55
        contactButtonWidthCons?.constant = 55
        showAllanotations()
        finderButton.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        if !videoView.isHidden {
            hideVideoView()
        }
        
        if leftViewTrailing.constant == self.view.bounds.width || rightViewLeading.constant == -self.view.bounds.width{
            leftViewTrailing.constant = 0
            rightViewLeading.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func meTapped(){
        generator.impactOccurred()
        buttonStackViewTrailingConstraint?.constant = -100
        buttonStackViewLeadingConstraint?.constant = 100
        messageButtonWidthCons?.constant = 70
        messageButtonHeightCons?.constant = 70
        mapButtonWidthCons?.constant = 35
        mapButtonHeightCons?.constant = 35
        contactButtonHeightCons?.constant = 35
        contactButtonWidthCons?.constant = 35
        showAllanotations()
        finderButton.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        if !videoView.isHidden {
            hideVideoView()
        }
        
        if leftViewTrailing.constant == self.view.bounds.width{
            
            UIView.animate(withDuration: 0.2, delay: 0, options:.curveEaseOut, animations: {
                self.leftViewTrailing.constant = 0
                self.view.layoutIfNeeded()
            })
            
            UIView.animate(withDuration: 0.3, delay: 0, options:.curveEaseIn, animations: {
                self.rightViewLeading.constant = -self.view.bounds.width
                self.view.layoutIfNeeded()
            })
        } else{
            rightViewLeading.constant = -self.view.bounds.width
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        getMessages()
    }
    
    @objc func sendMessage() {
        guard let user = self.selectedUser else { return }
        let recordMessageVC = RecordVideoViewController()
        recordMessageVC.mode = .messageMode
        recordMessageVC.toUserID = user.uid
        navigationController?.pushViewController(recordMessageVC, animated: true)
    }
    
    
    
    //MARK: Handle user interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !videoView.frame.contains(location) && videoView.isHidden == false{
            hideVideoView()
        } else {
            
        }
    }
    
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            hideVideoView()
        }
    }
    
    @objc func refreshTapped(){
        generator.impactOccurred()
        
        UIView.animate(withDuration: 0.3) {
            self.refreshButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        UIView.animate(withDuration: 0.3, delay: 0.15, options: .curveEaseIn, animations: {
            self.refreshButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi*2.0)
        }, completion: nil)
        
        loadUsers()
    }
    
    @objc func callTapped(){
        //check if user is currently in call, if not , call them
        guard let selectedUser = selectedUser else {return}
        guard let currentUser = currentUser else {return}
        ref.child("calling").child(currentUser.uid).setValue([selectedUser.uid : 1])
        let videoVC = VideoViewController()
        self.present(videoVC, animated: true, completion: nil)
    }
    
    @objc func heartTapped(){
        self.friendList.removeAll()
        self.friends.removeAll()
        guard let selectedUser = selectedUser else {return}
        guard let currentUser = currentUser else {return}
        
        if videoView.heartButton.currentImage == UIImage(named:"heartUntap"){
            videoView.heartButton.setImage(UIImage(named:"heartTap"), for: .normal)
            videoView.heartButton.backgroundColor = .white
            ref.child("friends").child(currentUser.uid).updateChildValues([selectedUser.uid : "true"])
        }else{
            videoView.heartButton.setImage(UIImage(named:"heartUntap"), for: .normal)
            videoView.heartButton.backgroundColor = .magenta
            ref.child("friends").child(currentUser.uid).child(selectedUser.uid).removeValue()
        }
    }
    
    func retrieveFriendList(completion: @escaping ([String]) -> Void){
        self.friendList.removeAll()
        guard let currentUser = currentUser else {return}
        ref.child("friends").child(currentUser.uid).observe(.value) { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let key = snap.key
                self.friendList.append(key)
            }
            completion(self.friendList)
        }
    }
    
    func retrieveFriendsData(friendList: [String]){
        self.friends.removeAll()
        print("friend list count \(friendList.count)")
        print("retrieve data called")
        for friend in friendList{
            ref.child("users").child(friend).observe(.value) { (snapshot) in
                guard let snapshot = snapshot.value as? [String:AnyObject] else {return}
                guard let name = snapshot["name"] as? String else {return}
                guard let username = snapshot["username"] as? String else{return}
                guard let uid = snapshot["uid"] as? String else {return}
                guard let lat = snapshot["latitude"] as? String else {return}
                guard let lon = snapshot["longitude"] as? String else{return}
                guard let profileVideo = snapshot["profileVideo"] as? String else {return}
                guard let token = snapshot["token"] as? String else {return}
                guard let profileImageUrl = snapshot["profileImageUrl"] as? String else { return }
                let onlineStatus = snapshot["onlineStatus"] as? Bool
                let user = User(uid: uid, token: token, username: username, name: name, profileImageUrl: profileImageUrl, gender: .male, lat: lat, lon: lon, profileVideoUrl: profileVideo, onlineStatus: onlineStatus)
                print(user)
                self.friends.append(user)
                DispatchQueue.main.async {
                    self.contactsCollectionView.reloadData()
                }
            }
        }
    }
    
    @objc func focusOneUser() {
        generator.impactOccurred()
        let annotationsInView = mapView.annotations(in: mapView.visibleMapRect)
        guard var usersInView = Array(annotationsInView) as? [User] else { return }
        usersInView.sort { (lhs: User, rhs: User) -> Bool in
            lhs.name > rhs.name
        }
        for userInView in usersInView {
            mapView.view(for: userInView)!.isHidden = true
        }
        if focusedUserIndex < usersInView.count {
            mapView.view(for: usersInView[focusedUserIndex])!.isHidden = false
            focusedUserIndex += 1
            if focusedUserIndex == usersInView.count {
                focusedUserIndex = 0
            }
        }
    }
    
    //MARK: HELPERS
    func showAllanotations() {
        for annotation in mapView.annotations {
            if mapView.view(for: annotation)?.isHidden == true {
                mapView.view(for: annotation)?.isHidden = false
            }
        }
    }
}



//MARK: CLLocationManagerDelegate
extension MapViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations[0] as CLLocation
        let distanceInMeters = newLocation.distance(from: userLocation ?? CLLocation(latitude: 0, longitude: 0))
        let center = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        if distanceInMeters > 100{
            userLocation = newLocation
            updateLocationToFirebase()
            mapView.setRegion(region, animated: true)
        }
    }
}

//MARK: MKMapViewDelegate
extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? User else { return nil }
        
        let identifier = "user"
        var view: NearbyUserView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? NearbyUserView{
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else{
            view = NearbyUserView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = false
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        let limeGreen =  UIColor(red: 172/255, green: 245/255, blue: 87/255, alpha: 1)
        if(annotation.onlineStatus == true){
            view.layer.borderColor = limeGreen.cgColor
        }else{
            view.layer.borderColor = UIColor.gray.cgColor
        }
        
        view.layer.borderWidth = 3
        return view
    }
    
    //MARK: DID SELECT USER
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedUser = view.annotation as? User
        guard let user = currentUser else {return}
        guard let userTapped = self.selectedUser else {return}
        
        ref.child("friends").child(user.uid).child(userTapped.uid).observe(.value) { (snapshot) in
            if snapshot.exists(){
                self.videoView.heartButton.setImage(UIImage(named:"heartTap"), for: .normal)
                self.videoView.heartButton.backgroundColor = .white
            }else{
                self.videoView.heartButton.setImage(UIImage(named:"heartUntap"), for: .normal)
                self.videoView.heartButton.backgroundColor = .magenta
            }
        }
        
        if user.uid != userTapped.uid{
            print("did not tap self, the user uid = \(userTapped.uid)")
            print(user.uid)
            showVideoView(withUser: userTapped.name, profileVideoUrl: userTapped.profileVideoUrl)
        } else{
            print("you tapped on yourself, do nothing")
        }
        
    }
}
//MARK: VIDEO VIEW RELATED
extension MapViewController: ShowProfileDelegate {
    
    func actionToMsg(_ message: Messages) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Reply", style: .default, handler: { (_) in
            let recordMessageVC = RecordVideoViewController()
            recordMessageVC.mode = .messageMode
            recordMessageVC.toUserID = message.senderID
            self.navigationController?.pushViewController(recordMessageVC, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
            
            let i = self.messages.firstIndex { (msg) -> Bool in
                msg.messageID == message.messageID
            }
            
            guard let index = i else { return }
            
            self.webService.deleteMessage(message) { (err) in
                guard err == nil else { return }
                DispatchQueue.main.async {
                    self.messages.remove(at: index)
                    self.messageTableView.beginUpdates()
                    
                    self.messageTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                    self.messageTableView.endUpdates()
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func showVideoView(withUser name: String, profileVideoUrl: String) {
        
        view.bringSubviewToFront(videoView)
        videoView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.videoView.alpha = 1
        }, completion: nil)
        videoView.videoURL = profileVideoUrl
        videoView.username = name
        videoView.configureView()
        videoView.play()
    }
    
    func hideVideoView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.videoView.alpha = 0
        }, completion: nil)
        self.videoView.stop()
        self.videoView.isHidden = true
    }
    
}


// MARK: TABLE/COLLECTION VIEW DELEGATE
extension MapViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.width
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
        cell.showProfileDelegate = self
        cell.isProfileHidden = videoView.isHidden
        cell.message = messages[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! MessageTableViewCell
        guard let videoURL = cell.message?.messageURL else { return }
        let videoPlayerVC = MessageVideoPlayerViewController()
        videoPlayerVC.url = videoURL
        self.navigationController?.pushViewController(videoPlayerVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let msg = messages[indexPath.row]
            webService.deleteMessage(msg) { (err) in
                guard err == nil else { return }
                DispatchQueue.main.async {
                    self.messages.remove(at: indexPath.row)
                    self.messageTableView.beginUpdates()
                    self.messageTableView.deleteRows(at: [indexPath], with: .fade)
                    self.messageTableView.endUpdates()
                }
            }
        }
    }
}

extension MapViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contactCell", for: indexPath) as! ContactsCollectionViewCell
        let friend = friends[indexPath.row]
        cell.nameLabel.text = friend.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.bounds.width - 40) / 4, height: (self.view.bounds.width - 40) / 4)
    }
}


class GradientView: UIView {
    
    var gradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradientView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupGradientView(){
        gradient.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradient.startPoint = CGPoint.zero
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.locations = [0,1.0]
        self.layer.addSublayer(gradient)
        
    }
    
}
