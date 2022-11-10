import Foundation

enum SolanaSocketError: Error {
    case disconnected
    case couldNotSerialize
}
public protocol SolanaSocketEventsDelegate: AnyObject {
    func connected()
    func accountNotification(notification: Response<BufferInfo<AccountInfo>>)
    func programNotification(notification: Response<ProgramAccount<AccountInfo>>)
    func signatureNotification(notification: Response<SignatureNotification>)
    func logsNotification(notification: Response<LogsNotification>)
    func unsubscribed(id: String)
    func subscribed(socketId: UInt64, id: String)
    func disconnected(reason: String, code: UInt16)
    func error(error: Error?)
}

public protocol SolanaWebSocketEvents: AnyObject {
    func connected(_: [String: String])
    func disconnected(_: String, _: UInt16)
    func text(_: String)
    func binary(_: Data)
    func pong(_: Data?)
    func ping(_: Data?)
    func error(_: Error?)
    func viabilityChanged(_: Bool)
    func reconnectSuggested(_: Bool)
    func cancelled()
}

public class SolanaSocket {
    private var enableDebugLogs: Bool
    private var request: URLRequest
    private weak var delegate: SolanaSocketEventsDelegate?

    init(endpoint: RPCEndpoint, enableDebugLogs: Bool = false) {
        self.request = URLRequest(url: endpoint.urlWebSocket)
        self.request.timeoutInterval = 5
        self.enableDebugLogs = enableDebugLogs
    }

    public func start(delegate: SolanaSocketEventsDelegate) {
        self.delegate = delegate
    }

    public func stop() {
        self.delegate = nil
    }

    public func accountSubscribe(publickey: String) -> Result<String, Error> {
        let method: SocketMethod = .accountSubscribe
        let params: [Encodable] = [ publickey, ["commitment": "recent", "encoding": "base64"] ]
        let request = SolanaRequest(method: method.rawValue, params: params)
        return writeToSocket(request: request)
    }

    func accountUnsubscribe(socketId: UInt64) -> Result<String, Error> {
        let method: SocketMethod = .accountUnsubscribe
        let params: [Encodable] = [socketId]
        let request = SolanaRequest(method: method.rawValue, params: params)
        return writeToSocket(request: request)
    }

    public func signatureSubscribe(signature: String) -> Result<String, Error> {
        let method: SocketMethod = .signatureSubscribe
        let params: [Encodable] = [signature, ["commitment": "confirmed", "encoding": "base64"]]
        let request = SolanaRequest(method: method.rawValue, params: params)
        return writeToSocket(request: request)
    }

    func signatureUnsubscribe(socketId: UInt64) -> Result<String, Error> {
        let method: SocketMethod = .signatureUnsubscribe
        let params: [Encodable] = [socketId]
        let request = SolanaRequest(method: method.rawValue, params: params)
        return writeToSocket(request: request)
    }

    public func logsSubscribe(mentions: [String]) -> Result<String, Error> {
        let method: SocketMethod = .logsSubscribe
        let params: [Encodable] = [["mentions": mentions], ["commitment": "confirmed", "encoding": "base64"]]
        let request = SolanaRequest(method: method.rawValue, params: params)
        return writeToSocket(request: request)
    }

    public func logsSubscribeAll() -> Result<String, Error> {
        let method: SocketMethod = .logsSubscribe
        let params: [Encodable] = ["all", ["commitment": "confirmed", "encoding": "base64"]]
        let request = SolanaRequest(method: method.rawValue, params: params)
        return writeToSocket(request: request)
    }

    func logsUnsubscribe(socketId: UInt64) -> Result<String, Error> {
        let method: SocketMethod = .logsUnsubscribe
        let params: [Encodable] = [socketId]
        let request = SolanaRequest(method: method.rawValue, params: params)
        return writeToSocket(request: request)
    }

    public func programSubscribe(publickey: String) -> Result<String, Error> {
        let method: SocketMethod = .programSubscribe
        let params: [Encodable] = [publickey, ["commitment": "confirmed", "encoding": "base64"]]
        let request = SolanaRequest(method: method.rawValue, params: params)
        return writeToSocket(request: request)
    }

    func programUnsubscribe(socketId: UInt64) -> Result<String, Error> {
        let method: SocketMethod = .programUnsubscribe
        let params: [Encodable] = [socketId]
        let request = SolanaRequest(method: method.rawValue, params: params)
        return writeToSocket(request: request)
    }

    private func writeToSocket(request: SolanaRequest) -> Result<String, Error> {
        fatalError()
    }
}
