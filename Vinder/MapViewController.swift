import UIKit
import CoreLocation
import MapKit
import AVKit


class MapViewController: UIViewController {
    
    var locationManager:CLLocationManager = CLLocationManager()
    var mapView : MKMapView = MKMapView()
    var currentLocation: CLLocation = CLLocation()
    var nearbyUsers : [NearbyUser] = []
    
    var videoView : VideoView!
    
    var container : UIView = UIView()
    var buttonContainer : UIView = UIView()
    var videoContainer : UIView = UIView()
    var callButton : UIButton = UIButton()
    var sendMessageButton : UIButton = UIButton()
    
    let maleColor : UIColor = UIColor(red: 98, green: 98, blue: 247, alpha: 1)
    let femaleColor : UIColor = UIColor(red: 255, green: 166, blue: 236, alpha: 1)
    
    
    //MARK: Initiate setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set up map view
        mapView.delegate = self
        
        mapView.register(NearbyUserView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        //adding testing annotation
        let user1 = NearbyUser(username: "adamck6302438", imageName: "Ray", coordinate: CLLocationCoordinate2D(latitude: 43.644311, longitude: -79.402225), gender: UserGender.male)
        let user2 = NearbyUser(username: "myley_cyrus", imageName: "miley-cyrus", coordinate: CLLocationCoordinate2D(latitude: 43.594311, longitude: -79.502225), gender: UserGender.female)
        let user3 = NearbyUser(username: "kawhi", imageName: "kawhi", coordinate: CLLocationCoordinate2D(latitude: 43.624311, longitude: -79.566666), gender: UserGender.male)
        mapView.addAnnotation(user1)
        mapView.addAnnotation(user2)
        mapView.addAnnotation(user3)
        
        
        //set up views
        setUpContainers()
        setUpButtons()
        container.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        determineCurrentLocation()
        self.view.sendSubviewToBack(mapView)
    }
    
    func createMapView()
    {
        mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.center = view.center
        mapView.showsUserLocation = true
        view.addSubview(mapView)
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
    
    
    
    
    //MARK: Fetch nearby users
    func fetchUsers(){
        //TODO: network call to fetch nearby user locatino
    }
    
    
    
    
    //MARK: Setup Popup Views
    func setUpContainers(){
        self.view.addSubview(container)
        container.backgroundColor = UIColor.white
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [container.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 150),
             container.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
             container.trailingAnchor.constraint(equalTo: self.view.trailingAnchor ,constant: -50),
             container.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -250)
            ])
        container.layer.cornerRadius = 20
        
        self.container.addSubview(buttonContainer)
        buttonContainer.backgroundColor = UIColor.blue
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonContainer.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            buttonContainer.heightAnchor.constraint(equalToConstant: 100),
            buttonContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            buttonContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20)
            ])
        
        self.container.addSubview(videoContainer)
        videoContainer.backgroundColor = UIColor.green
        videoContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoContainer.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            videoContainer.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            videoContainer.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            videoContainer.bottomAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: -20)
            ])
    }
    
    func setUpButtons(){
        
        callButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        callButton.translatesAutoresizingMaskIntoConstraints = false
        callButton.layer.cornerRadius = 0.5 * callButton.bounds.size.width
        callButton.clipsToBounds = true
        callButton.backgroundColor = UIColor.red
        callButton.setImage(UIImage(named: "call"), for: .normal)
        callButton.imageView?.contentMode = .scaleAspectFit
        callButton.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        
        sendMessageButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
        sendMessageButton.layer.cornerRadius = 0.5 * callButton.bounds.size.width
        sendMessageButton.clipsToBounds = true
        sendMessageButton.backgroundColor = UIColor.yellow
        sendMessageButton.imageView?.contentMode = .scaleAspectFit
        sendMessageButton.setImage(UIImage(named: "message"), for: .normal)
        sendMessageButton.imageEdgeInsets = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        
        self.buttonContainer.addSubview(callButton)
        self.buttonContainer.addSubview(sendMessageButton)
        
        NSLayoutConstraint.activate([callButton.heightAnchor.constraint(equalToConstant: 50),
                                     callButton.widthAnchor.constraint(equalToConstant: 50),
                                     callButton.trailingAnchor.constraint(equalTo: buttonContainer.trailingAnchor, constant: -50),
                                     callButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 25)
                                     ])
        
        NSLayoutConstraint.activate([sendMessageButton.heightAnchor.constraint(equalToConstant: 50),
                                     sendMessageButton.widthAnchor.constraint(equalToConstant: 50),
                                     sendMessageButton.leadingAnchor.constraint(equalTo: buttonContainer.leadingAnchor, constant: 50),
                                     sendMessageButton.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 25)
            ])
    }
    
    
    func setUpVideoView(){
        self.videoContainer.addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: videoContainer.topAnchor),
            videoView.leadingAnchor.constraint(equalTo: videoContainer.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: videoContainer.trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: videoContainer.bottomAnchor)
            ])
        videoView.configure(url: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        videoView.isLoop = false
        videoView.play()
        print("play")
    }
    
    
    
    
    //MARK: Handle user interaction
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !container.frame.contains(location) && container.isHidden == false{
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
                self.container.alpha = 0
            }, completion: nil)
            self.container.isHidden = true
        }else {
            
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
        let userLocation:CLLocation = locations[0] as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        myAnnotation.title = "Current location"
        mapView.addAnnotation(myAnnotation)
        
    }
}





//MARK: MKMapViewDelegate
extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        container.isHidden = false
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
            self.container.alpha = 1
        }, completion: nil)
        
        print("\(view.annotation?.coordinate)")
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? NearbyUser else { return nil }

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
        
        //implement gender
//        if(view.annotation. == UserGender.male){
//            view.layer.borderColor = UIColor.blue.cgColor
//        }else{
//            view.layer.borderColor = UIColor.red.cgColor
//        }
        
        view.layer.borderWidth = 5
        return view
    }

    
    
    
}
