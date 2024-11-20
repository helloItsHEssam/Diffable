import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(DiffableMacros)
import DiffableMacros

let testMacros: [String: Macro.Type] = [
    "Diffable": DiffableMacro.self
]
#endif

final class DiffableTests: XCTestCase {

    func testValidMemberAndGenerateOptionSet() throws {
        #if canImport(DiffableMacros)
        assertMacroExpansion(
            #"""
            @Diffable
            public struct Config: Equatable {
                
                var name: String
            }
            """#
            ,
            expandedSource:
                #"""
                public struct Config: Equatable {
                    
                    var name: String
                
                    public struct Difference: OptionSet {
                        public let rawValue: Int
                        public init(rawValue: Int) {
                            self.rawValue = rawValue
                        }
                        static let name = Difference(rawValue: 1 << 0)
                    }
                
                    public func computeDifference(from other: Self) -> Difference {
                        var difference: Difference = []
                        var currentCopy: Self? = self
                        var otherCopy: Self? = other
                
                        if currentCopy?.name != otherCopy?.name {
                            difference.insert(.name)
                        }
                
                        currentCopy = nil
                        otherCopy = nil
                        return difference
                    }
                }
                """#,
            macros: testMacros
        )
        
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInvalidMemberAndGenerateOptionSet() throws {
        #if canImport(DiffableMacros)
        assertMacroExpansion(
            #"""
            @Diffable
            public struct Config: Equatable {
                
                var name: String
                private var family: String
            }
            """#
            ,
            expandedSource:
                #"""
                public struct Config: Equatable {
                    
                    var name: String
                    private var family: String
                
                    public struct Difference: OptionSet {
                        public let rawValue: Int
                        public init(rawValue: Int) {
                            self.rawValue = rawValue
                        }
                        static let name = Difference(rawValue: 1 << 0)
                    }
                
                    public func computeDifference(from other: Self) -> Difference {
                        var difference: Difference = []
                        var currentCopy: Self? = self
                        var otherCopy: Self? = other
                
                        if currentCopy?.name != otherCopy?.name {
                            difference.insert(.name)
                        }
                
                        currentCopy = nil
                        otherCopy = nil
                        return difference
                    }
                }
                """#,
            macros: testMacros
        )
        
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testValidMemberWithPrivateSetAndGenerateOptionSet() throws {
        #if canImport(DiffableMacros)
        assertMacroExpansion(
            #"""
            @Diffable
            public struct Config: Equatable {
                
                private var name6: String
                private(set) var name7: String
            }
            """#
            ,
            expandedSource:
                #"""
                public struct Config: Equatable {
                    
                    private var name6: String
                    private(set) var name7: String
                
                    public struct Difference: OptionSet {
                        public let rawValue: Int
                        public init(rawValue: Int) {
                            self.rawValue = rawValue
                        }
                        static let name7 = Difference(rawValue: 1 << 0)
                    }
                
                    public func computeDifference(from other: Self) -> Difference {
                        var difference: Difference = []
                        var currentCopy: Self? = self
                        var otherCopy: Self? = other
                
                        if currentCopy?.name7 != otherCopy?.name7 {
                            difference.insert(.name7)
                        }
                
                        currentCopy = nil
                        otherCopy = nil
                        return difference
                    }
                }
                """#,
            macros: testMacros
        )
        
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testInvalidComputedMemberAndGenerateOptionSet() throws {
        #if canImport(DiffableMacros)
        assertMacroExpansion(
            #"""
            @Diffable
            public struct Config: Equatable {
                
                public var name6: String = {
                    return "hello 6"
                }()
                var name5: String {
                    return "hello"
                }
            }
            """#
            ,
            expandedSource:
                #"""
                public struct Config: Equatable {
                    
                    public var name6: String = {
                        return "hello 6"
                    }()
                    var name5: String {
                        return "hello"
                    }
                
                    public struct Difference: OptionSet {
                        public let rawValue: Int
                        public init(rawValue: Int) {
                            self.rawValue = rawValue
                        }
                        static let name6 = Difference(rawValue: 1 << 0)
                    }
                
                    public func computeDifference(from other: Self) -> Difference {
                        var difference: Difference = []
                        var currentCopy: Self? = self
                        var otherCopy: Self? = other
                
                        if currentCopy?.name6 != otherCopy?.name6 {
                            difference.insert(.name6)
                        }
                
                        currentCopy = nil
                        otherCopy = nil
                        return difference
                    }
                }
                """#,
            macros: testMacros
        )
        
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testGenerateDifferecneFunction() throws {
        #if canImport(DiffableMacros)
        assertMacroExpansion(
            #"""
            @Diffable
            public struct Config: Equatable {
                
                public var name6: String = {
                    return "hello 6"
                }()
            }
            """#
            ,
            expandedSource:
                #"""
                public struct Config: Equatable {
                    
                    public var name6: String = {
                        return "hello 6"
                    }()
                
                    public struct Difference: OptionSet {
                        public let rawValue: Int
                        public init(rawValue: Int) {
                            self.rawValue = rawValue
                        }
                        static let name6 = Difference(rawValue: 1 << 0)
                    }
                
                    public func computeDifference(from other: Self) -> Difference {
                        var difference: Difference = []
                        var currentCopy: Self? = self
                        var otherCopy: Self? = other

                        if currentCopy?.name6 != otherCopy?.name6 {
                            difference.insert(.name6)
                        }
                
                        currentCopy = nil
                        otherCopy = nil
                        return difference
                    }
                }
                """#,
            macros: testMacros
        )
        
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testGenerateDifferecneClosue() throws {
        #if canImport(DiffableMacros)
        assertMacroExpansion(
            #"""
            @Diffable
            public struct Config: Equatable {
                
                public var name6: String = {
                    return "hello 6"
                }()
                public var wrongVariable: () -> Void
            }
            """#
            ,
            expandedSource:
                #"""
                public struct Config: Equatable {
                    
                    public var name6: String = {
                        return "hello 6"
                    }()
                    public var wrongVariable: () -> Void
                
                    public struct Difference: OptionSet {
                        public let rawValue: Int
                        public init(rawValue: Int) {
                            self.rawValue = rawValue
                        }
                        static let name6 = Difference(rawValue: 1 << 0)
                        static let wrongVariable = Difference(rawValue: 1 << 1)
                    }
                
                    public func computeDifference(from other: Self) -> Difference {
                        var difference: Difference = []
                        var currentCopy: Self? = self
                        var otherCopy: Self? = other

                        if currentCopy?.name6 != otherCopy?.name6 {
                            difference.insert(.name6)
                        }
                
                        if currentCopy?.wrongVariable != otherCopy?.wrongVariable {
                            difference.insert(.wrongVariable)
                        }
                
                        currentCopy = nil
                        otherCopy = nil
                        return difference
                    }
                }
                """#,
            macros: testMacros
        )
        
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
