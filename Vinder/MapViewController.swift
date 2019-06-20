import UIKit
import CoreLocation
import MapKit
import FirebaseDatabase
import FirebaseAuth

class MapViewController: UIViewController {
  
  let currentUser = Auth.auth().currentUser
  var locationManager:CLLocationManager = CLLocationManager()
  let ref = Database.database().reference()
  var userLocation : CLLocation? {
    didSet{
      updateLocationToFirebase()
    }
  }
  var leftViewTrailing :NSLayoutConstraint!
  var rightViewLeading: NSLayoutConstraint!
  
  let user1 = NearbyUser(username: "adamck6302438", image: "Ray.jpg", coordinate: CLLocationCoordinate2D(latitude: 43.644311, longitude: -79.402225))
  let user2 = NearbyUser(username: "myley_cyrus", image: "miley-cyrus.jpg", coordinate: CLLocationCoordinate2D(latitude: 32.444311, longitude: -59.402225))
  let user3 = NearbyUser(username: "kawhi", image: "kawhi.jpg", coordinate: CLLocationCoordinate2D(latitude: 35.444311, longitude: -79.666666))
  
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
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    
    setupViews()
    determineCurrentLocation()
  }
  
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
    
    mapView.addAnnotation(user1)
    mapView.addAnnotation(user2)
    mapView.addAnnotation(user3)
    
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
      
      logoutButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
      logoutButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
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
      ])
  }
  
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
  
  func loadInitialData(){
    
  }
  
  @objc func logoutTapped(){
    do{
      try Auth.auth().signOut()
      self.view.window?.rootViewController?.dismiss(animated:true, completion:nil)
    }catch let err{
      print(err)
    }
  }
  
  @objc func settingTapped(){
    let settingsVC = SettingViewController()
    self.present(settingsVC, animated: true, completion: nil)
  }
  
  func updateLocationToFirebase(){
    guard let uid = currentUser?.uid else{return}
    guard let location = userLocation else{return}
    self.ref.child("users").child(uid).updateChildValues(["latitude":location.coordinate.latitude])
    self.ref.child("users").child(uid).updateChildValues(["longitude":location.coordinate.longitude])
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
      self.view.layoutIfNeeded()
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
      self.view.layoutIfNeeded()
    }
  }
}

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


extension MapViewController : MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? NearbyUser else { return nil }
    
    let identifier = "neaby user"
    var view: MKMarkerAnnotationView
    
    if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
      dequeuedView.annotation = annotation
      view = dequeuedView
    } else{
      view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
      view.canShowCallout = false
      view.calloutOffset = CGPoint(x: -5, y: 5)
      view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
    }
    return view
  }
  
}

extension MapViewController: UITableViewDelegate{
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return self.view.bounds.width
  }
}

extension MapViewController: UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell
    cell.nameLabel.text = "name"
    cell.distanceLabel.text = "10km"
    return cell
  }
}

extension MapViewController:UICollectionViewDelegate{

}

extension MapViewController: UICollectionViewDataSource{
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