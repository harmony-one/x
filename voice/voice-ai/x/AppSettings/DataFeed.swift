import Foundation

class DataFeed {
    static let shared = DataFeed()
    var sources = [
        "https://github.com/harmony-one/x/blob/main/data/btc.json",
        "https://github.com/harmony-one/x/blob/main/data/one.json"
    ]


    func getData(completion: @escaping (String?) -> Void) {
        var aggregatedContent = ""
        let group = DispatchGroup()

        for urlString in sources {
            guard let url = URL(string: urlString) else { continue }

            group.enter()
            fetchContent(from: url) { content in
                if let content = content, let parsedContentArray = self.parseJsonContent(content) {
                    // Append the content
                    aggregatedContent += parsedContentArray.joined(separator: " ") + " "
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion(aggregatedContent.isEmpty ? nil : aggregatedContent)
        }
    }

    private func fetchContent(from url: URL, completion: @escaping (String?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
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
    func publicFuncToTestParseJsonContent(_ content: String?) -> [String]? {
        guard let content = content else {
            return nil
        }
        return self.parseJsonContent(content)
    }
    
    func publicFuncToTestFetchContent(from url: URL, completion: @escaping (String?) -> Void) {
        self.fetchContent(from: url, completion: completion)
    }
}
