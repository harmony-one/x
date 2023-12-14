import Foundation

class DataFeed {
    static let shared = DataFeed()
    
    var newsMap = [
        "BTC": "https://github.com/harmony-one/x/blob/main/data/btc.txt",
        "ONE": "https://github.com/harmony-one/x/blob/main/data/one.txt",
        "APPL": "https://github.com/harmony-one/x/blob/main/data/appl.txt",
        "SOCCER": "https://github.com/harmony-one/x/blob/main/data/soccer.txt"
    ]

    // If "followNews" is not part of the newsMap, the preexisting value will remain
    func getData(followNews: String, completion: @escaping (String?) -> Void) {
        guard let urlString = newsMap[followNews.uppercased()],
              let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        fetchContent(from: url) { content in
            guard let content = content, let parsedContentArray = self.parseJsonContent(content) else {
                completion(nil)
                return
            }

            let aggregatedContent = parsedContentArray.joined(separator: " ")
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
                return response.payload.blob.rawLines
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
