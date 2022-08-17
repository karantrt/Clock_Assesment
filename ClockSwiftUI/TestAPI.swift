//
//  TestAPI.swift
//  ClockSwiftUI
//
//  Created by TRT-IOS-03 on 01/08/22.
//

import SwiftUI

struct TestAPI: View {
    var body: some View {
        NavigationView {
//            ContentView()
//                .navigationTitle("Clock")
//                .toolbar {
//                    ToolbarItem {
//                        Button("Call API") {
//                           callApi()
//                        }
//                    }
//                }
//
        }
    }
    func callApi() {
        

        let request = NSMutableURLRequest(url: NSURL(string: "http://api.timezonedb.com/v2.1/list-time-zone")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.setValue("GGXK7ECJN647", forHTTPHeaderField: "key")
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error)
          } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
          }
        })

        dataTask.resume()
    }
}

struct TestAPI_Previews: PreviewProvider {
    static var previews: some View {
        TestAPI()
    }
}
