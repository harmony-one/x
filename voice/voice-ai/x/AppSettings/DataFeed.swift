import Foundation

class DataFeed {
    
    static let shared = DataFeed()

    // TODO: Fetch data from all sources
    var btcSource = "https://github.com/harmony-one/x/blob/main/data/btc.json"
    // var ethSource =
    var oneSource = "https://github.com/harmony-one/x/blob/main/data/one.json"
    
    func getData(from urlString: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        fetchContent(from: url) { content in
            guard let content = content else {
                completion(nil)
                return
            }

            if let parsedContentArray = self.parseJsonContent(content) {
                let joinedContent = parsedContentArray.joined(separator: " ")
                print(joinedContent)
                completion(joinedContent)
            } else {
                completion(nil)
            }
        }
    }
    
    private func fetchContent(from url: URL, completion: @escaping (String?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let content = String(data: data, encoding: .utf8)
            completion(content)
        }

        task.resume()
    }

    private func parseJsonContent(_ content: String) -> [String]? {
        struct Response: Codable {
            let payload: Payload
        }

        struct Payload: Codable {
            let blob: Blob
        }

        struct Blob: Codable {
            let rawLines: [String]
        }

        guard let jsonData = content.data(using: .utf8) else {
            return nil
        }

        do {
            let response = try JSONDecoder().decode(Response.self, from: jsonData)
            let rawLines = response.payload.blob.rawLines

            let jsonString = rawLines.joined()

            if let data = jsonString.data(using: .utf8) {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = json as? [String: Any],
                   let contentArray = dictionary["content"] as? [String] {
                    return contentArray
                }
            }

            return nil
        } catch {
            print("JSON parsing error: \(error)")
            return nil
        }
    }
}

extension DataFeed {
    public func publicFuncToTestParseJsonContent(_ content: String?) -> [String]? {
        guard let content = content else {
            return nil
        }
        return self.parseJsonContent(content)
    }
    
    public func publicFuncToTestFetchContent(from url: URL, completion: @escaping (String?) -> Void) {
        self.fetchContent(from: url, completion: completion)
    }
}
