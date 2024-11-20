//
//  DiffableMacroError.swift
//  Diffable
//
//  Created by HEssam on 11/20/24.
//

import Foundation

/// An error type representing issues encountered when applying the `@Diffable` macro.
///
/// The `DiffableMacroError` enum includes specific cases to describe why the macro application might fail.
///
/// ## Overview
///
/// The `DiffableMacroError` enum provides error cases to identify invalid usage of the `@Diffable` macro.
/// Each case explains the reason for the error, such as applying the macro to an unsupported type or
/// a type that does not conform to the `Equatable` protocol.
///
/// ### Error Cases
/// - `shouldBeClassOrStructOrEnum`: Indicates that the `@Diffable` macro is applied to an unsupported type.
/// - `shouldConformToEquatableProtocol`: Indicates that the type to which the `@Diffable` macro is applied
///   does not conform to the `Equatable` protocol.
///
/// ## Topics
/// ### Enumeration Cases
/// - ``DiffableMacroError/shouldBeClassOrStructOrEnum``
/// - ``DiffableMacroError/shouldConformToEquatableProtocol``
///
/// ### Properties
/// - ``DiffableMacroError/description``
///
public enum DiffableMacroError: CustomStringConvertible, Error {
    
    /// Indicates that the `@Diffable` macro is applied to an unsupported type.
    ///
    /// The `@Diffable` macro can only be used with classes, structs, or enums.
    /// Applying it to other types will trigger this error.
    case shouldBeClassOrStructOrEnum
    
    /// Indicates that the type to which the `@Diffable` macro is applied does not conform to `Equatable`.
    ///
    /// The `@Diffable` macro relies on the `Equatable` protocol to compare properties
    /// of two instances. Types that do not conform to `Equatable` cannot use this macro.
    case shouldConformToEquatableProtocol
    
    /// A human-readable description of the error.
    ///
    /// The `description` property provides a concise explanation of the error, detailing
    /// why the `@Diffable` macro cannot be applied.
    public var description: String {
        switch self {
        case .shouldBeClassOrStructOrEnum:
            return "@Diffable is only available in class, struct or enum"
            
        case .shouldConformToEquatableProtocol:
            return "@Diffable should Conform to `Equatable` protocol"
        }
    }
}
