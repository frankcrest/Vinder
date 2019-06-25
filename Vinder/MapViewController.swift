import UIKit
import CoreLocation
import MapKit


class MapViewController: UIViewController {
    
    //MARK: PROPERTIES
    private let webService = WebService()
    private var messages: [Messages] = []
//    let ref = Database.database().reference()
    var locationManager:CLLocationManager = CLLocationManager()
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
        mp.showsUserLocation = true
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
        setupViews()
        fetchMessages()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineCurrentLocation()
            
        if !webService.isLoggedIn() {
            presentLogInNavigationController()
        }
    }
    
    private func presentLogInNavigationController() {
         let loginNav = UINavigationController()
        loginNav.viewControllers = [LoginViewController()]
        present(loginNav, animated: true, completion: nil)
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
        
        self.centerView.addSubview(videoView)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
        videoView.rightButton.setImage(UIImage(named: "call"), for: .normal)
        videoView.leftButton.setImage(UIImage(named: "message"), for: .normal)
        
        videoView.leftButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        //    videoView.rightButton.addTarget(self, action: Selector, for: <#T##UIControl.Event#>)
        
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
    
    fileprivate func fetchMessages() {
        webService.fetchAllMessages { (msgs) -> (Void) in
            guard let msgs = msgs else {
                print("cant fetch messages")
                return
            }
            self.messages = msgs
        }
        messageTableView.reloadData()
    }
    
    func updateLocationToFirebase(){

        guard let location = userLocation else{return}
        let lat = String(format: "%f", location.coordinate.latitude)
        let lon = String(format: "%f", location.coordinate.longitude)

        webService.updateUserWithLocation(lat: lat, lon: lon)
        
        loadUsers()
    }
    
    //MARK: ACTIONS
    
    @objc func logoutTapped(){

        videoView.isHidden = true
        do{
            try webService.logOut()
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
    }
    
    @objc func sendMessage() {
        
        guard let user = self.selectedUser else { return }
        let recordMessageVC = RecordVideoViewController()
        recordMessageVC.mode = .messageMode
        recordMessageVC.toUser = user
        present(recordMessageVC, animated: true, completion: nil)
        
    }
    
    
    
    //MARK: Handle user interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !videoView.frame.contains(location) && videoView.isHidden == false{
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
                self.videoView.alpha = 0
            }, completion: nil)
            self.videoView.stop()
            self.videoView.isHidden = true
        }else {
            
        }
    }
    
    @objc func callTapped(){
        let videoVC = VideoViewController()
        //    videoVC.userChannelID = self.selectedUser?.uid
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
        if distanceInMeters > 100{
            userLocation = newLocation
        }
        
        let center = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
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
        videoView.isHidden = false
        videoView.setUpViews()
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
            self.videoView.alpha = 1
        }, completion: nil)
        
        videoView.configure(url: selectedUser!.profileVideoUrl)
        videoView.play()
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
        
        cell.nameLabel.text = messages[indexPath.row].sender
        cell.distanceLabel.text = "10km"
        cell.videoURL = URL(string: messages[indexPath.row].messageURL)
        cell.startPreview()
        //need to change message model to store sender name 
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! MessageTableViewCell
        cell.playVideo()
    }
    
}

extension MapViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contactCell", for: indexPath) as! ContactsCollectionViewCell
        cell.nameLabel.text = "name"
        return cell
    }
}

extension MapViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.bounds.width - 40) / 4, height: (self.view.bounds.width - 40) / 4)
    }
}

