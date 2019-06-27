import UIKit
import CoreLocation
import MapKit
import Firebase


class MapViewController: UIViewController {
    
    //MARK: PROPERTIES
    private let webService = WebService()
    private var messages: [Messages] = []
    let ref = Database.database().reference()
    var currentUser = Auth.auth().currentUser
    var locationManager:CLLocationManager = CLLocationManager()
    var userLocations = [UserLocation]()
    var userLocation : CLLocation? {
        didSet{
            updateLocationToFirebase()
        }
    }
    
    var leftViewTrailing :NSLayoutConstraint!
    var rightViewLeading: NSLayoutConstraint!
    var users : [User] = []
    let maleColor : UIColor = UIColor(red: 98, green: 98, blue: 247, alpha: 1)
    let femaleColor : UIColor = UIColor(red: 255, green: 166, blue: 236, alpha: 1)
    var selectedUser: User?
    var swipeRecog = UISwipeGestureRecognizer()
    
    //MARK: VIEW PROPERTIES

    let videoView : VideoView = {
        let v = VideoView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 20
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let buttonContainer:UIView = {
        let v = UIView()
        v.backgroundColor = .blue
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    let navView: UIView = {
        let v = UIView()
        v.backgroundColor = .magenta
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let mapView : MKMapView = {
        let mp = MKMapView()
        mp.mapType = MKMapType.standard
        mp.isZoomEnabled = true
        mp.isScrollEnabled = true
        mp.showsUserLocation = false
        mp.translatesAutoresizingMaskIntoConstraints = false
        return mp
    }()
    
    let logoutButton: UIButton = {
        let b = UIButton()
        b.setTitle("logout", for: .normal)
        b.backgroundColor = .white
        b.setTitleColor(.black, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return b
    }()
    
    let settingButton: UIButton = {
        let b = UIButton()
        b.setTitle("setting", for: .normal)
        b.backgroundColor = .white
        b.setTitleColor(.black, for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.addTarget(self, action: #selector(settingTapped), for: .touchUpInside)
        return b
    }()
    
    let contactButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.layer.cornerRadius = 25
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(contactTapped), for: .touchUpInside)
        return b
    }()
    
    let mapButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.layer.cornerRadius = 25
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(mapTapped), for: .touchUpInside)
        return b
    }()
    
    let meButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.layer.cornerRadius = 25
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(meTapped), for: .touchUpInside)
        return b
    }()
    
    let buttonStackView:UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.alignment = .fill
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let messageTableView:UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.register(MessageTableViewCell.self, forCellReuseIdentifier: "messageCell")
        return tb
    }()
    
    let contactsCollectionView:UICollectionView = {
        let flowLayout = CustomFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.register(ContactsCollectionViewCell.self, forCellWithReuseIdentifier: "contactCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
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
    
    //MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(NearbyUserView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        setupViews()
        getMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            presentLogInNavigationController()
        } else{
            currentUser = Auth.auth().currentUser
            determineCurrentLocation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        ref.child("users").removeAllObservers()
        self.videoView.stop()
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
        self.view.addSubview(navView)
        self.view.addSubview(centerView)
        self.view.addSubview(leftView)
        self.view.addSubview(rightView)
        
        self.centerView.addSubview(mapView)
        self.view.addSubview(logoutButton)
        self.view.addSubview(settingButton)
        self.view.addSubview(buttonStackView)
        self.buttonStackView.addArrangedSubview(contactButton)
        self.buttonStackView.addArrangedSubview(mapButton)
        self.buttonStackView.addArrangedSubview(meButton)
        
        self.rightView.addSubview(messageTableView)
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        self.leftView.addSubview(contactsCollectionView)
        contactsCollectionView.delegate = self
        contactsCollectionView.dataSource = self
        
        self.view.addSubview(videoView)
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        videoView.rightButton.setImage(UIImage(named: "call"), for: .normal)
        videoView.leftButton.setImage(UIImage(named: "message"), for: .normal)
        
        videoView.leftButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        videoView.rightButton.addTarget(self, action: #selector(callTapped), for: .touchUpInside)
        videoView.addGestureRecognizer(swipeRecog)
        swipeRecog.addTarget(self, action: #selector(swipeHandler(_:)))
        swipeRecog.direction = .up
        
        leftViewTrailing = leftView.trailingAnchor.constraint(equalTo: self.centerView.leadingAnchor, constant: 0)
        rightViewLeading = rightView.leadingAnchor.constraint(equalTo: self.centerView.trailingAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            
            navView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            navView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            navView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            navView.heightAnchor.constraint(equalToConstant: 90),
            
            centerView.topAnchor.constraint(equalTo: self.navView.bottomAnchor, constant: 0),
            centerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            centerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            centerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0),
            
            leftViewTrailing,
            leftView.topAnchor.constraint(equalTo: self.navView.bottomAnchor, constant: 0),
            leftView.heightAnchor.constraint(equalToConstant: self.view.bounds.height),
            leftView.widthAnchor.constraint(equalToConstant: self.view.bounds.width),
            
            rightViewLeading,
            rightView.topAnchor.constraint(equalTo: self.navView.bottomAnchor, constant: 0),
            rightView.heightAnchor.constraint(equalToConstant: self.view.bounds.height),
            rightView.widthAnchor.constraint(equalToConstant: self.view.bounds.width),
            
            mapView.topAnchor.constraint(equalTo: self.centerView.topAnchor, constant: 0),
            mapView.leadingAnchor.constraint(equalTo: self.centerView.leadingAnchor, constant: 0),
            mapView.trailingAnchor.constraint(equalTo: self.centerView.trailingAnchor, constant: 0),
            mapView.bottomAnchor.constraint(equalTo: self.centerView.bottomAnchor, constant: 0),
            
            logoutButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
            logoutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            logoutButton.heightAnchor.constraint(equalToConstant: 50),
            logoutButton.widthAnchor.constraint(equalToConstant: 50),
            
            settingButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
            settingButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            settingButton.heightAnchor.constraint(equalToConstant: 50),
            settingButton.widthAnchor.constraint(equalToConstant: 50),
            
            contactButton.heightAnchor.constraint(equalToConstant: 50),
            contactButton.widthAnchor.constraint(equalToConstant: 50),
            
            mapButton.heightAnchor.constraint(equalToConstant: 50),
            mapButton.widthAnchor.constraint(equalToConstant: 50),
            
            meButton.heightAnchor.constraint(equalToConstant: 50),
            meButton.widthAnchor.constraint(equalToConstant: 50),
            
            buttonStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStackView.heightAnchor.constraint(equalToConstant: 50),
            
            messageTableView.topAnchor.constraint(equalTo: self.rightView.topAnchor, constant: 0),
            messageTableView.leadingAnchor.constraint(equalTo: self.rightView.leadingAnchor, constant: 0),
            messageTableView.trailingAnchor.constraint(equalTo: self.rightView.trailingAnchor, constant: 0),
            messageTableView.bottomAnchor.constraint(equalTo: self.rightView.bottomAnchor, constant: 0),
            
            contactsCollectionView.topAnchor.constraint(equalTo: self.leftView.topAnchor, constant: 0),
            contactsCollectionView.leadingAnchor.constraint(equalTo: self.leftView.leadingAnchor, constant: 0),
            contactsCollectionView.trailingAnchor.constraint(equalTo: self.leftView.trailingAnchor, constant: 0),
            contactsCollectionView.bottomAnchor.constraint(equalTo: self.leftView.bottomAnchor, constant: 0),
            
            videoView.topAnchor.constraint(equalTo: self.centerView.topAnchor, constant: 50),
            videoView.leadingAnchor.constraint(equalTo: self.centerView.leadingAnchor, constant: 20),
            videoView.trailingAnchor.constraint(equalTo: self.centerView.trailingAnchor ,constant: -20),
            videoView.bottomAnchor.constraint(equalTo: self.centerView.bottomAnchor, constant: -200),
            
            ])
    }
    //MARK: FETCH MESSAGE
    
    func getMessages() {
        
        self.webService.fetchAllMessages { (allMessages) -> (Void) in
            print("getting msgs")
            guard let allMessages = allMessages else { return }
            self.messages = allMessages
            self.messages.sort { (msg1, msg2) -> Bool in
                return msg1.timestamp > msg2.timestamp
            }
        }
        
        DispatchQueue.main.async {
            self.messageTableView.reloadData()
        }
    }
    
    
    //MARK: LOAD USER AND LOCATE
    func determineCurrentLocation()
    {
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
        self.users.removeAll()
        webService.fetchUsers { (users) in
            guard let users = users else {
                print("faied fetching users")
                return
            }
            for user in users {
                self.mapView.addAnnotation(user)
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
    
    func updateLocationToFirebase(){
        guard let location = userLocation else{return}
        let lat = String(format: "%f", location.coordinate.latitude)
        let lon = String(format: "%f", location.coordinate.longitude)
        guard let user = currentUser else {return}
        print("uid: \(user.uid)")
        webService.updateUserWithLocation(lat: lat, lon: lon, uid: user.uid)
        
        loadUsers()
    }
    
    //MARK: ACTIONS
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
        self.present(settingsVC, animated: true, completion: nil)
    }
    
    @objc func contactTapped(){
        if rightViewLeading.constant == -self.view.bounds.width{
            
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
        if leftViewTrailing.constant == self.view.bounds.width || rightViewLeading.constant == -self.view.bounds.width{
            leftViewTrailing.constant = 0
            rightViewLeading.constant = 0
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func meTapped(){
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
        recordMessageVC.toUser = user
        navigationController?.pushViewController(recordMessageVC, animated: true)
    }
    
    
    
    //MARK: Handle user interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !videoView.frame.contains(location) && videoView.isHidden == false{
            hideVideoView()
        }else {

        }
    }
    
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            hideVideoView()
        }
    }
    
    @objc func callTapped(){
        guard let selectedUser = selectedUser else {return}
        guard let currentUser = currentUser else {return}
        ref.child("calling").child(currentUser.uid).setValue([selectedUser.uid : 1])
        
        let videoVC = VideoViewController()
        self.present(videoVC, animated: true, completion: nil)
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
        
        print(distanceInMeters)
        
        if distanceInMeters > 100{
            print("user have moved 100 metres")
            userLocation = newLocation
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
        
        view.layer.cornerRadius = view.frame.size.height/2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.masksToBounds = true
        
        if(annotation.gender == UserGender.male){
            view.layer.borderColor = UIColor.blue.cgColor
        }else{
            view.layer.borderColor = UIColor.red.cgColor
        }
        
        view.layer.borderWidth = 5
        return view
    }
    
    //MARK: DID SELECT USER
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedUser = view.annotation as? User
        guard let user = currentUser else {return}
        guard let userTapped = self.selectedUser else {return}
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
    
    func showVideoView(withUser name: String, profileVideoUrl: String) {
        
        view.bringSubviewToFront(videoView)
        videoView.isHidden = false
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
            self.videoView.alpha = 1
        }, completion: nil)
        videoView.videoURL = profileVideoUrl
        videoView.username = name
        videoView.configureView()
        videoView.play()
    }
    
    func hideVideoView() {
        
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
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
    
}

extension MapViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contactCell", for: indexPath) as! ContactsCollectionViewCell
        cell.nameLabel.text = "name"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.bounds.width - 40) / 4, height: (self.view.bounds.width - 40) / 4)
    }
    
}

