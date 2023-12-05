class IntentManager {
    static let shared = IntentManager()
    var actionHandler: ActionHandlerProtocol?
    
    private init() {
        
    }
    
    public func setActionHandler(actionHandler: ActionHandlerProtocol) {
        self.actionHandler = actionHandler
    }
    
    public func handleAction(action: ActionType) {
        if self.actionHandler != nil {
            self.actionHandler?.handle(actionType: action)
        }
    }
}
