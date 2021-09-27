//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>

import UIKit

class FixedFrameViewController: UIViewController {
   
   @IBOutlet weak var redView: UIView!
   
   @IBOutlet weak var blueView: UIView!
   
   @IBOutlet weak var bottomContainer: UIView!
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      layoutWithInitializer()
      //layoutWithVisualFormatLanguage()
      //layoutWithAnchor()
   }
}







extension FixedFrameViewController {
   func layoutWithInitializer() {
    redView.translatesAutoresizingMaskIntoConstraints = false
    blueView.translatesAutoresizingMaskIntoConstraints = false
    
   }
}





























extension FixedFrameViewController {
   func layoutWithVisualFormatLanguage() {
     
   }
}





























extension FixedFrameViewController {
   func layoutWithAnchor() {
     
   }
}





























