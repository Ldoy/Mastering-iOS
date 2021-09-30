//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>


import UIKit

class OperationQueueViewController: UIViewController {
    //    let queue = OperationQueue.main //UI업데이트 할 때 여기에 추가
    let queue = OperationQueue() // background에서 작업하는 operationQueue가 생김
    
    var isCancelled = false
    
    @IBAction func startOperation(_ sender: Any) {
        
        isCancelled = false
        
        self.queue.addOperation {
            autoreleasepool {
                for _ in 1..<100 {
                    guard !self.isCancelled else { return }
                    print("1️⃣|", separator: " ", terminator: " ")
                    Thread.sleep(forTimeInterval: 0.3)
                }
            }
        }
        
        let op = BlockOperation {
            autoreleasepool {
                for _ in 1..<100 {
                    guard !self.isCancelled else { return }
                    print("2️⃣|", separator: " ", terminator: " ")
                    Thread.sleep(forTimeInterval: 0.6)
                }
            }
        }
        
        
        // 실행완료된 오퍼레이션엔 추가하면 안됨 
        op.addExecutionBlock {
                for _ in 1..<100 {
                    guard !self.isCancelled else { return }
                    print("🧱|", separator: " ", terminator: " ")
                    Thread.sleep(forTimeInterval: 0.5)
                }
        }
        queue.addOperation(op)

        
        let op2 = CustomOperation(type: "💩")
        queue.addOperation(op2)
                
        op.completionBlock = {
            // 오퍼레이션에 구현된 작업이 완료된 후 출력
            print("-------------완료----------------")
        }
    }
    
    @IBAction func cancelOperation(_ sender: Any) {
        self.isCancelled = true
        queue.cancelAllOperations()
    }
    
    deinit {
        print(self, #function)
    }
}
