import UIKit
import CoreLocation
import MapKit
class MapViewController: UIViewController {
    
    var locationManager:CLLocationManager = CLLocationManager()
    var mapView : MKMapView = MKMapView()
    var currentLocation: CLLocation = CLLocation()
    var nearbyUsers : [NearbyUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        mapView.delegate = self
        
//        mapView.register(NearbyUserMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        mapView.register(NearbyUserView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        let user1 = NearbyUser(username: "adamck6302438", imageName: "Ray", coordinate: CLLocationCoordinate2D(latitude: 43.644311, longitude: -79.402225))
        let user2 = NearbyUser(username: "myley_cyrus", imageName: "miley-cyrus", coordinate: CLLocationCoordinate2D(latitude: 43.594311, longitude: -79.502225))
        let user3 = NearbyUser(username: "kawhi", imageName: "kawhi", coordinate: CLLocationCoordinate2D(latitude: 43.624311, longitude: -79.566666))
        
        mapView.addAnnotation(user1)
        mapView.addAnnotation(user2)
        mapView.addAnnotation(user3)
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
    
    
    //fetch nearby users
    func fetchUsers(){
        
    }
    
}

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


//extension MapViewController : MKMapViewDelegate {

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? NearbyUser else { return nil }
//
//        let identifier = "user"
//        var view: MKMarkerAnnotationView
//
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView{
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else{
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = false
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
//
//}
