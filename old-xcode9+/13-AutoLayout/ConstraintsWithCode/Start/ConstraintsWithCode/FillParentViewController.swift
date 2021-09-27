//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>

import UIKit

class FillParentViewController: UIViewController {
   
   @IBOutlet weak var bottomContainer: UIView!
   
   @IBOutlet weak var blueView: UIView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      //layoutWithInitializer()
      //layoutWithVisualFormatLanguage()
      layoutWithAnchor()
   }
}









extension FillParentViewController {
   func layoutWithInitializer() {
    let leading = NSLayoutConstraint(item: blueView, attribute: .leading, relatedBy: .equal, toItem: bottomContainer, attribute: .leading, multiplier: 1.0, constant: 0)
    let trailing = NSLayoutConstraint(item: blueView, attribute: .trailing, relatedBy: .equal, toItem: bottomContainer, attribute: .trailing, multiplier: 1.0, constant: 0)
    let top = NSLayoutConstraint(item: blueView, attribute: .top, relatedBy: .equal, toItem: bottomContainer, attribute: .top, multiplier: 1.0, constant: 0)
    let bottom = NSLayoutConstraint(item: blueView, attribute: .bottom, relatedBy: .equal, toItem: bottomContainer, attribute: .bottom, multiplier: 1.0, constant: 0)
    blueView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([leading, top, trailing, bottom])
    
    
   }
}



































extension FillParentViewController {
   func layoutWithVisualFormatLanguage() {
    blueView.translatesAutoresizingMaskIntoConstraints = false
        //MARK: 수평
    let horzFmt = "|[b]|"
    let vertFmt = "V:|[b]|"
    let views: [String: Any] = ["b": blueView]
    
    let horzConstraints = NSLayoutConstraint.constraints(withVisualFormat: horzFmt, options: [], metrics: nil, views: views)
    let vertConstraints = NSLayoutConstraint.constraints(withVisualFormat: vertFmt, options: [], metrics: nil, views: views)
    
    NSLayoutConstraint.activate(horzConstraints + vertConstraints)
   }
}




































extension FillParentViewController {
   func layoutWithAnchor() {
    blueView.translatesAutoresizingMaskIntoConstraints = false
    blueView.leadingAnchor.constraint(equalTo: bottomContainer.leadingAnchor).isActive = true
    blueView.trailingAnchor.constraint(equalTo: bottomContainer.trailingAnchor).isActive = true
    blueView.topAnchor.constraint(equalTo: bottomContainer.topAnchor).isActive = true
    blueView.bottomAnchor.constraint(equalTo: bottomContainer.bottomAnchor).isActive = true
   }
}
















































