/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation



// Runs query data task, and stores results in array of Tracks
class QueryService {
    func makePostCall() {
        let todosEndpoint: String = "http://kvtest6.azurewebsites.net/Token"
        guard let todosURL = URL(string: todosEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        var todosUrlRequest = URLRequest(url: todosURL)
        todosUrlRequest.httpMethod = "POST"
        todosUrlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let d = "grant_type=password&username=admin@test2.com&password=testTEST11!@".data(using:String.Encoding.ascii, allowLossyConversion: false)
        todosUrlRequest.httpBody = d;
        //let newTodo: [String: Any] = ["title": "My First todo", "completed": false, "userId": 1]
        //let jsonTodo: Data
        //do {
        //    jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
        //    todosUrlRequest.httpBody = jsonTodo
        //} catch {
        //    print("Error: cannot create JSON from todo")
        //    return
        //}
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: todosUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let receivedTodo = try JSONSerialization.jsonObject(with: responseData,
                                                                          options: []) as? [String: Any] else {
                                                                            print("Could not get JSON from responseData as dictionary")
                                                                            return
                }
                print(receivedTodo);
                
                //print("The todo is: " + receivedTodo.description)
                //
                //guard let todoID = receivedTodo["id"] as? Int else {
                //    print("Could not get todoID as int from JSON")
                //    return
                //}
                //print("The ID is: \(todoID)")
            } catch  {
                print("error parsing response from POST on /todos")
                return
            }
        }
        task.resume()
    }
    
    
    
    typealias JSONDictionary = [String: Any]
    //typealias QueryResult = ([Track]?, String) -> ()
    
    // 1
    let defaultSession = URLSession(configuration: .default)
    // 2
    var dataTask: URLSessionDataTask?
    //var tracks: [Track] = []
    var errorMessage = ""
    
    func getSearchResults(searchTerm: String, completion: @escaping (String) -> Void) {
        // 1
        dataTask?.cancel()
        // 2
        if var urlComponents = URLComponents(string: "http://kvtest6.azurewebsites.net/api/test2") {
            //urlComponents.query = "media=music&entity=song&term=\(searchTerm)"
            // 3
            guard let url = urlComponents.url else { return }
            // 4
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                // 5
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    //self.updateSearchResults(data)
                    print("A");
                    print(data);
                    print(response);
                    DispatchQueue.main.async {
                        completion(self.errorMessage)
                    }
                }
            }
            // 7
            dataTask?.resume()
        }
    }
    
}

