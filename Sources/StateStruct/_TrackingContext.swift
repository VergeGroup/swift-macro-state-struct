import os.lock
import Foundation.NSThread

public final class _TrackingContext: Sendable, Hashable {
  
  public static func == (lhs: _TrackingContext, rhs: _TrackingContext) -> Bool {
    // ``_TrackingContext`` is used only for embedding into the struct.
    // It always returns true when checked for equality to prevent
    // interfering with the actual equality check of the struct.
    return true
  }
  
  public func hash(into hasher: inout Hasher) {
    0.hash(into: &hasher)
  }

  @inlinable
  public var path: PropertyPath? {
    get {
      infoBox.withLockUnchecked {
        $0[Unmanaged.passUnretained(Thread.current).toOpaque()]?.path
      }
    }
    set {
      infoBox.withLockUnchecked {
        $0[Unmanaged.passUnretained(Thread.current).toOpaque(), default: .init()].path = newValue
      }
    }
  }
  
  public var identifier: AnyHashable? {
    get {
      infoBox.withLockUnchecked {
        $0[Unmanaged.passUnretained(Thread.current).toOpaque()]?.identifier
      }
    }
    set {
      infoBox.withLockUnchecked {
        $0[Unmanaged.passUnretained(Thread.current).toOpaque(), default: .init()].identifier = newValue
      }
    }
  }
      
  @usableFromInline
  struct Info {
    @usableFromInline
    var path: PropertyPath?
    
    @usableFromInline
    var identifier: AnyHashable?
    
    @inlinable
    init() {
    }
  }

  @usableFromInline
  let infoBox: OSAllocatedUnfairLock<[UnsafeMutableRawPointer: Info]> = .init(
    uncheckedState: [:]
  )

  public init() {
  }
}
