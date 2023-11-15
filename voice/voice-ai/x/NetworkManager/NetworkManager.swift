import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed(Error)
    case responseError(Int)
    case dataParsingError(Error)
    case unknown
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct NetworkResponse<T> {
    let statusCode: Int
    let data: T
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private let session: URLSession
    
    private init() {
        self.session = URLSession(configuration: .default)
    }
    
    private func createURL(endpoint: String, parameters: [String: String]?) -> URL? {
        var components = URLComponents(string: APIEnvironment.baseURL + endpoint)
        components?.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
    
    private func createRequestBody<T: Encodable>(from object: T) -> Data? {
        return try? JSONEncoder().encode(object)
    }
    
    private func setAuthorizationHeader(token: String, request: inout URLRequest) {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    
    func requestData<T: Codable>(from endpoint: String, method: HTTPMethod, parameters: [String: String]? = nil, body: Data? = nil, token: String? = nil, completion: @escaping (Result<NetworkResponse<T>, NetworkError>) -> Void) {
        
        guard let url = createURL(endpoint: endpoint, parameters: parameters) else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if let token = token {
            setAuthorizationHeader(token: token, request: &request)
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.unknown))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(.responseError(httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.unknown))
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    let networkResponse = NetworkResponse(statusCode: httpResponse.statusCode, data: decodedData)
                    completion(.success(networkResponse))
                } catch {
                    completion(.failure(.dataParsingError(error)))
                }
            }
        }
        
        task.resume()
    }
}