//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>


import UIKit

class MinimumMarginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        if #available(iOS 11.0, *) {
        viewRespectsSystemMinimumLayoutMargins = false
        } else {
            
        }
    }
   
   override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      
      if #available(iOS 11.0, *) {
         dump(systemMinimumLayoutMargins)
      } else {
         
      }
      
      dump(view.layoutMargins)
   }
}
