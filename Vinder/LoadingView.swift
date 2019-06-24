import UIKit
import Lottie

class LoadingView: UIView {
    
    let progressLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        let lottieView = AnimationView(name: "simple")
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.text = "uploading: ..."
        progressLabel.textColor = .purple
        
        addSubview(lottieView)
        addSubview(progressLabel)
        
        NSLayoutConstraint.activate([
            lottieView.centerXAnchor.constraint(equalTo: centerXAnchor),
            lottieView.centerYAnchor.constraint(equalTo: centerYAnchor),
            lottieView.widthAnchor.constraint(equalToConstant: 150),
            lottieView.heightAnchor.constraint(equalToConstant: 150),
            
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.topAnchor.constraint(equalTo: lottieView.bottomAnchor),
            progressLabel.heightAnchor.constraint(equalToConstant: 44)
            ])
        
        lottieView.loopMode = .loop
        lottieView.play()
        
    }
    
}
