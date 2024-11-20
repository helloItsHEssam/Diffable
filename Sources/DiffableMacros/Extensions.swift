//
//  Extensions.swift
//  Diffable
//
//  Created by HEssam on 11/20/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

extension InheritanceClauseSyntax? {
    
    func checkConformEquatableProtocol() throws {
        guard let self else {
            throw DiffableMacroError.shouldConformToEquatableProtocol
        }
        
        let inheritedIdentifierTypes = self.inheritedTypes
            .compactMap { $0.type.as(IdentifierTypeSyntax.self) }
        let identifierTypeSyntax = inheritedIdentifierTypes.compactMap { $0.as(IdentifierTypeSyntax.self) }
        if !identifierTypeSyntax.contains(where: { $0.name.text == "Equatable" }) {
            throw DiffableMacroError.shouldConformToEquatableProtocol
        }
    }
}

extension [VariableDeclSyntax] {
    
    func removeComputedVariables() -> Self {
        return filter {
            let hasAccessorBlock = $0.bindings
                .compactMap { $0.as(PatternBindingSyntax.self) }
                .filter { $0.accessorBlock == nil }
            return !hasAccessorBlock.isEmpty
        }
    }
    
    func removePrivateVariables() -> Self {
        return filter {
            let validDecls = $0.modifiers
                .compactMap { $0.as(DeclModifierSyntax.self) }
            
            guard !validDecls.isEmpty else {
                return true
            }
            
            return validDecls.contains {
                let isPrivateTokenKind = $0.name.tokenKind == .keyword(.private)
                let hasSetDetail = $0.detail?.detail.tokenKind == .identifier("set")
                
                if  isPrivateTokenKind && hasSetDetail {
                    return true
                    
                } else {
                    return $0.name.tokenKind != .keyword(.private)
                }
            }
        }
    }
}

