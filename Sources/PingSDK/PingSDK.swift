import Foundation

struct Ping {
    func log(
        api: String,
        lat: Double = 0.0,
        lon: Double = 0.0,
        time: Int64 = Int64(NSDate().timeIntervalSince1970), // epoch timestamp in seconds
        ext: String = "", // extra text payload
        callback: @escaping (Any) -> Void
    ) {
        let payload: [String: Any] = [
            "lat": lat,
            "lon": lon,
            "time": time,
            "ext": ext,
        ]

        // implement POST payload to API Server
        post(to: api, payload: payload)
        
        // callback should happen after POST
        return callback(payload)
    }
    func post(to api: String, payload: [String: Any]){
        
        let jsonData = try? JSONSerialization.data(withJSONObject: payload)
        
        let url = URL(string: api)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/JSON", forHTTPHeaderField: "Accept")

        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            guard let data = data, error == nil else{
                print(error?.localizedDescription ?? "No Description")
                return
            }
            let result = try? JSONSerialization.jsonObject(with: data, options: [])
            if let result = result as? [String: Any]{
                print(result)
            }
            let response = response as! HTTPURLResponse
            let status = response.statusCode
            print("Response Code: \(status)")
            
            
            
        }
        task.resume()
    }
}


