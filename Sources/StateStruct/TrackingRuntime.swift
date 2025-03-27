import Foundation
import os.lock

public enum TrackingRuntime {

  /// no tracking
  @usableFromInline
  static func dynamic_processGet<Value>(
    component: consuming PropertyPath.Component,
    value: Value,
    trackingContext: borrowing _TrackingContext
  ) -> Value {

    if 
      let ref = trackingContext.trackingResultRef,
      let path = trackingContext.path
    {
      ref.accessorRead(path: path.pushed(component))
    }
      
    if var value = value as? TrackingObject, let ref = trackingContext.trackingResultRef {

      if value._tracking_context.trackingResultRef !== ref {
        value._tracking_context = _TrackingContext(trackingResultRef: ref)
      }

      value._tracking_context.path = trackingContext.path?.pushed(component)

      return value as! Value
    } else {
      return value
    }

  }
  
  /// no tracking
  @inlinable
  public static func processGet<Value>(
    component: consuming PropertyPath.Component,
    value: Value,
    trackingContext: borrowing _TrackingContext
  ) -> Value {

    return dynamic_processGet(component: component, value: value, trackingContext: trackingContext)
    
  }
  
  /// no tracking
  @inlinable
  public static func processGet<WrappedValue>(
    component: consuming PropertyPath.Component,
    value: Optional<WrappedValue>,
    trackingContext: borrowing _TrackingContext
  ) -> WrappedValue? {
        
    return dynamic_processGet(
      component: component,
      value: value,
      trackingContext: trackingContext
    )
    
  }

  /// tracking
  @usableFromInline
  static func static_processGet<Value: TrackingObject>(
    component: consuming PropertyPath.Component,
    value: Value,
    trackingContext: borrowing _TrackingContext
  ) -> Value {

    trackingContext.trackingResultRef?.accessorRead(path: trackingContext.path?.pushed(component))

    var value = value

    if let ref = trackingContext.trackingResultRef {

      if value._tracking_context.trackingResultRef !== ref {
        value._tracking_context = _TrackingContext(trackingResultRef: ref)
      }

      value._tracking_context.path = trackingContext.path?.pushed(component)

      return value
    } else {
      return value
    }

  }
  
  /// tracking
  @inlinable
  public static func processGet<Value: TrackingObject>(
    component: consuming PropertyPath.Component,
    value: Value,
    trackingContext: borrowing _TrackingContext
  ) -> Value {    
    static_processGet(component: component, value: value, trackingContext: trackingContext)
  }
  
  /// tracking
  @inlinable
  public static func processGet<WrappedValue: TrackingObject>(
    component: consuming PropertyPath.Component,
    value: Optional<WrappedValue>,
    trackingContext: borrowing _TrackingContext
  ) -> WrappedValue? {    
    guard let value = value else {
      return nil
    }
    return static_processGet(component: component, value: value, trackingContext: trackingContext)
  }
  

  /// no tracking
  @usableFromInline
  static func dynamic_processModify<Value>(
    component: consuming PropertyPath.Component,
    trackingContext: borrowing _TrackingContext,
    storage: borrowing _BackingStorage<Value>
  ) {

    trackingContext.trackingResultRef?.accessorModify(path: trackingContext.path?.pushed(component))

    if var value = storage.value as? TrackingObject, let ref = trackingContext.trackingResultRef {

      if value._tracking_context.trackingResultRef !== ref {
        value._tracking_context = _TrackingContext(trackingResultRef: ref)
      }
      value._tracking_context.path = trackingContext.path?.pushed(component)

      storage.value = value as! Value
    }
  }
  
  /// no tracking
  public static func processModify<Value>(
    component: consuming PropertyPath.Component,
    trackingContext: borrowing _TrackingContext,
    storage: borrowing _BackingStorage<Value>
  ) {
    
    dynamic_processModify(component: component, trackingContext: trackingContext, storage: storage)
  }
  
  /// no tracking
  public static func processModify<WrappedValue>(
    component: consuming PropertyPath.Component,
    trackingContext: borrowing _TrackingContext,
    storage: borrowing _BackingStorage<Optional<WrappedValue>>
  ) {
    
    dynamic_processModify(component: component, trackingContext: trackingContext, storage: storage)
  }
   
  /// no tracking
  public static func processModify<Value: TrackingObject>(
    component: consuming PropertyPath.Component,
    trackingContext: borrowing _TrackingContext,
    storage: borrowing _BackingStorage<Value>
  ) {
    
    trackingContext.trackingResultRef?.accessorModify(path: trackingContext.path?.pushed(component))
    
    var value = storage.value
    
    if let ref = trackingContext.trackingResultRef {
      
      if value._tracking_context.trackingResultRef !== ref {
        value._tracking_context = _TrackingContext(trackingResultRef: ref)
      }
      value._tracking_context.path = trackingContext.path?.pushed(component)
      
      storage.value = value
    }

  }
  
  /// no tracking
  public static func processModify<WrappedValue: TrackingObject>(
    component: consuming PropertyPath.Component,
    trackingContext: borrowing _TrackingContext,
    storage: borrowing _BackingStorage<Optional<WrappedValue>>
  ) {
        
    trackingContext.trackingResultRef?.accessorModify(path: trackingContext.path?.pushed(component))
    
    guard var value = storage.value else {
      return
    }
    
    if let ref = trackingContext.trackingResultRef {
      
      if value._tracking_context.trackingResultRef !== ref {
        value._tracking_context = _TrackingContext(trackingResultRef: ref)
      }
      value._tracking_context.path = trackingContext.path?.pushed(component)
      
      storage.value = value
    }

  }

}
