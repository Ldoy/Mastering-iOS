//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>

import UIKit

class SessionDelegateTableViewController: UITableViewController {
   
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var descLabel: UILabel!
   
   var session: URLSession!
   
   // Code Input Point #3
    var buffer: Data?
   // Code Input Point #3
   
   @IBAction func sendReqeust(_ sender: Any) {
      guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/books/3") else {
         fatalError("Invalid URL")
      }
      
      // Code Input Point #1
    session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
    buffer = Data()
    
      // Code Input Point #1
    
    let task = session.dataTask(with: url)
    task.resume()
    
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      // Code Input Point #6
      //메모리 leak방지하기 위해서 테스크 모두 종료 후 리소스 정리
    // session.finishTasksAndInvalidate()
    // 그냥 바로 취소
    session.invalidateAndCancel()
      // Code Input Point #6
   }
}

// Code Input Point #2
extension SessionDelegateTableViewController: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        // 서버로부터 최초로 응답을 받았을 때 -> 응답정보는 3번째 파라미터로 전달
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            completionHandler(.cancel)
            return
        }
        
        // 성공하면 데이터 전달
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        //서버에서 데이터가 전송될 때마다 반복적으로 호출됨
        // 따라서 마지막 데이터는 완전히 끝난 데이터가 아님 따라서 데이터를 누적해야함
        buffer?.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // 데이터 전송이 완료된 다음 호출됨, 마지막 오류없이 정상이라면 nil이 전달됨
        if let error = error {
            showErrorAlert(with: error.localizedDescription)
        } else {
            parse()
        }
    }
}
// Code Input Point #2

extension SessionDelegateTableViewController {
   func parse() {
      // Code Input Point #4
    guard let data = buffer else {
        showErrorAlert(with: "")
        return
    }
      // Code Input Point #4
      
      let decoder = JSONDecoder()
      
      decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
         let container = try decoder.singleValueContainer()
         let dateStr = try container.decode(String.self)
         
         let formatter = ISO8601DateFormatter()
         formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
         return formatter.date(from: dateStr)!
      })
      
      // Code Input Point #5
    do {
        let detail = try decoder.decode(BookDetail.self, from: data)
        if detail.code == 200 {
            titleLabel.text = detail.book.title
        }
    } catch {
        showErrorAlert(with: error.localizedDescription)
    }
      // Code Input Point #5
   }
}
