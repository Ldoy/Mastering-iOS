//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>

import UIKit

class CustomOperation: Operation {
    // 출력할 값
    let type: String
    
    // 생성자
    init(type: String) {
        self.type = type
    }
    
    override func main() {
        autoreleasepool {
            guard !isCancelled else { return }
            for _ in 1..<100 {
                guard !isCancelled else { return }
                print("\(self.type)", separator: " ", terminator: " ")
                Thread.sleep(forTimeInterval: 0.9)
            }
        }
    }
}































