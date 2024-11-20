import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct DiffableMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {

        // Equatable
        try declaration.inheritanceClause.checkConformEquatableProtocol()

        // valid type
        let isValidType = declaration.check(
            validTypes: EnumDeclSyntax.self,
            StructDeclSyntax.self,
            ClassDeclSyntax.self
        )
        if !isValidType {
            throw DiffableMacroError.shouldBeClassOrStructOrEnum
        }

        let members = declaration.memberBlock.members
        let validVarDecls = members
            .compactMap({ $0.decl.as(VariableDeclSyntax.self) })
            .removeComputedVariables() // remove computed
            .removePrivateVariables() // remove private and private(set)
        
        let variableNames = validVarDecls
            .flatMap(\.bindings)
            .extractVariablesName()
        
        // modifier
        let modifier = declaration.getModifierIfExists()
        var optionSetDeclaration = String.generatePrefixOptionSetDeclaration(withModifier: modifier)
        var diffFunctionDeclaration = String.generatePrefixDiffFunctionDeclaration()
        
        for item in variableNames.enumerated() {
            let newOption = "static let \(item.element) = Difference(rawValue: 1 << \(item.offset))"
            optionSetDeclaration += "\n\(newOption)"
            
            let ifStatement = """
                            
                            if currentCopy?.\(item.element) != otherCopy?.\(item.element) {
                                difference.insert(.\(item.element))
                            }
                            
                            """
            diffFunctionDeclaration += ifStatement
        }
        
        optionSetDeclaration += """
        }
        """
        
        diffFunctionDeclaration += """
        
            currentCopy = nil
            otherCopy = nil
            return difference
        }
        """

        if let modifier {
            optionSetDeclaration = modifier + " \(optionSetDeclaration)"
            diffFunctionDeclaration = modifier + " \(diffFunctionDeclaration)"
        }
        
        return [.init(stringLiteral: optionSetDeclaration),
                .init(stringLiteral: diffFunctionDeclaration)]
    }
}

private extension DeclGroupSyntax {
    
    func check(validTypes types: DeclSyntaxProtocol.Type...) -> Bool {
        var isValidType = false
        for type in types {
            isValidType = isValidType || self.is(type.self)
        }
        
        guard isValidType else {
            return false
        }
        
        return true
    }
    
    func getModifierIfExists() -> String? {
        return modifiers
            .first?.name.text
    }
}

private extension String {
    
    static func generatePrefixOptionSetDeclaration(withModifier modifier: String? = nil) -> Self {
        let defineOptionSetString = "struct Difference: OptionSet {"
        let rawValueString = "let rawValue: Int"
        let initString = """
            init(rawValue: Int) {
                self.rawValue = rawValue
            }
            """
        
        var resultValue = defineOptionSetString
        
        if let modifier, modifier == "public" {
            resultValue += """
            \(modifier) \(rawValueString)
            \(modifier) \(initString)
            """
        } else {
            resultValue += """
            \(rawValueString)
            \(initString)
            """
        }
        
        return resultValue
    }
    
    static func generatePrefixDiffFunctionDeclaration() -> Self {
        """
        func computeDifference(from other: Self) -> Difference {
            var difference: Difference = []
            var currentCopy: Self? = self
            var otherCopy: Self? = other
        
        """
    }
    
}

private extension [PatternBindingListSyntax.Element] {
    
    func extractVariablesName() -> [String] {
        return compactMap { $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text }
    }
}

@main
struct DiffablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        DiffableMacro.self
    ]
}
