import os.lock
import Foundation.NSThread

public struct _TrackingContext: Sendable, Hashable {
  
  public static func == (lhs: _TrackingContext, rhs: _TrackingContext) -> Bool {
    // ``_TrackingContext`` is used only for embedding into the struct.
    // It always returns true when checked for equality to prevent
    // interfering with the actual equality check of the struct.
    return true
  }
  
  public func hash(into hasher: inout Hasher) {
    0.hash(into: &hasher)
  }
      
  public struct Info {
    
    public var path: PropertyPath?
    
    public var identifier: AnyHashable?
    
    public var currentResultRef: TrackingResultRef?

    init(
      path: PropertyPath? = nil,
      identifier: AnyHashable? = nil,
      currentResultRef: TrackingResultRef?
    ) {
      self.path = path
      self.identifier = identifier
      self.currentResultRef = currentResultRef
    }
      
  }

  private let infoBox: OSAllocatedUnfairLock<Info>
  
  public var path: PropertyPath? {
    get {
      infoBox.withLockUnchecked {
        $0.path
      }
    }
    nonmutating set {
      infoBox.withLockUnchecked {
        $0.path = newValue
      }
    }
  }
  
  public var identifier: AnyHashable? {
    get {
      infoBox.withLockUnchecked {
        $0.identifier
      }
    }
    nonmutating set {
      infoBox.withLockUnchecked {
        $0.identifier = newValue
      }
    }
  }
  
  public var trackingResultRef: TrackingResultRef? {
    get {
      infoBox.withLock { $0.currentResultRef }
    }
    nonmutating set {
      infoBox.withLock {
        $0.currentResultRef = newValue
      }
    }
  }
    
  public init(trackingResultRef: TrackingResultRef) {
    infoBox = .init(
      uncheckedState: .init(
        currentResultRef: trackingResultRef
      )
    )
  }
  
  public init() {
    infoBox = .init(
      uncheckedState: .init(
        currentResultRef: nil
      )
    )
  }
}
