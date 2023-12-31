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

protocol NetworkManagerProtocol {
    func createURL(endpoint: String, parameters: [String: String]?) -> URL?
    func setAuthorizationHeader(token: String, request: inout URLRequest)
    func setCustomHeader(field: String, value: String, request: inout URLRequest)
    func requestData<T: Codable>(from endpoint: String, method: HTTPMethod, parameters: [String: String]?, body: Data?, token: String?, customHeaders: [String: String]?, completion: @escaping (Result<NetworkResponse<T>, NetworkError>) -> Void)
}

extension NetworkManagerProtocol {
    func requestData<T: Codable>(from endpoint: String, method: HTTPMethod, completion: @escaping (Result<NetworkResponse<T>, NetworkError>) -> Void) {
        requestData(from: endpoint, method: method, parameters: nil, body: nil, token: nil, customHeaders: nil, completion: completion)
    }
    
    func requestData<T: Codable>(from endpoint: String, method: HTTPMethod, body: Data, customHeaders: [String: String], completion: @escaping (Result<NetworkResponse<T>, NetworkError>) -> Void) {
        requestData(from: endpoint, method: method, parameters: nil, body: body, token: nil, customHeaders: customHeaders, completion: completion)
    }
    
    func requestData<T: Codable>(from endpoint: String, method: HTTPMethod, customHeaders: [String: String], completion: @escaping (Result<NetworkResponse<T>, NetworkError>) -> Void) {
        requestData(from: endpoint, method: method, parameters: nil, body: nil, token: nil, customHeaders: customHeaders, completion: completion)
    }
    
    func requestData<T: Codable>(from endpoint: String, method: HTTPMethod, body: Data, completion: @escaping (Result<NetworkResponse<T>, NetworkError>) -> Void) {
        requestData(from: endpoint, method: method, parameters: nil, body: nil, token: nil, customHeaders: nil, completion: completion)
    }
}

class NetworkManager: NetworkManagerProtocol {
    static let shared = NetworkManager()
    private let session: URLSession

    private init() {
        session = URLSession(configuration: .default)
    }

    internal func createURL(endpoint: String, parameters: [String: String]?) -> URL? {
        var components = URLComponents(string: APIEnvironment.getBaseURL() + endpoint)
        components?.queryItems = parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }

    /// Sets an Authorization Header.
    ///
    /// This method sets the bearer token in the authorization header.
    /// It's used to authenticate requests by including the access token provided by the server.
    public func setAuthorizationHeader(token: String, request: inout URLRequest) {
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    /// Sets a custom header for the request.
    ///
    /// - Parameters:
    ///   - field: The name of the header field to set.
    ///   - value: The value for the header field.
    ///   - request: The URLRequest to modify.
    public func setCustomHeader(field: String, value: String, request: inout URLRequest) {
        request.setValue(value, forHTTPHeaderField: field)
    }

    func requestData<T: Codable>(from endpoint: String, method: HTTPMethod, parameters: [String: String]? = nil, body: Data? = nil, token: String? = nil, customHeaders: [String: String]? = nil, completion: @escaping (Result<NetworkResponse<T>, NetworkError>) -> Void) {
        guard let url = createURL(endpoint: endpoint, parameters: parameters) else {
            completion(.failure(.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Set custom headers if any
        customHeaders?.forEach { key, value in
            setCustomHeader(field: key, value: value, request: &request)
        }

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

                guard (200 ... 299).contains(httpResponse.statusCode) else {
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
