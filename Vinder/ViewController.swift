//
//  ViewController.swift
//  Vinder
//
//  Created by Frank Chen on 2019-06-18.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .cyan
   
    // Do any additional setup after loading the view.
  }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        let vc = VideoViewController()
//        present(vc, animated: true, completion: nil)
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let mc = MapViewController()
        present(mc, animated: true, completion: nil)
    }


}

