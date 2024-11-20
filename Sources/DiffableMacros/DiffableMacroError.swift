//
//  DiffableMacroError.swift
//  Diffable
//
//  Created by HEssam on 11/20/24.
//

import Foundation

public enum DiffableMacroError: CustomStringConvertible, Error {
    case shouldBeClassOrStructOrEnum
    case shouldConformToEquatableProtocol
    
    public var description: String {
        switch self {
        case .shouldBeClassOrStructOrEnum:
            return "@DiffableMacro is only available in class, struct or enum"
            
        case .shouldConformToEquatableProtocol:
            return "@DiffableMacro should Conform to `Equatable` protocol"
        }
    }
}
