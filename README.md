# Diffable Macro  

## Overview  

The `@Diffable` macro provides an efficient way to calculate differences between two instances of a type by automatically generating code to compare properties. It ensures that you only focus on the high-level design of your types while leveraging the macro for advanced functionality.  

To use the `@Diffable` macro, the target type must:  
1. Be a `class`, `struct`, or `enum`.  
2. Conform to the `Equatable` protocol.  

The macro will generate an optimized implementation of difference computation for all `Equatable` properties in your type.  

When applied, the macro generates a computeDifference method that calculates the difference between two Config instances, returning a strongly-typed result indicating the changed properties.

## Example Usage  

```swift
@Diffable
public struct Config: Equatable {
    public var name: String
    public var id: UUID
}

// expandedSource
public struct Config: Equatable {
    public var name: String
    public var id: UUID

    public struct Difference: OptionSet {
        public let rawValue: Int        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        static let name = Difference(rawValue: 1 << 0)
        static let id = Difference(rawValue: 1 << 1)
    }

    public func computeDifference(from other: Self) -> Difference {
        var difference: Difference = []
        var currentCopy: Self? = self
        var otherCopy: Self? = other

        if currentCopy?.name != otherCopy?.name {
            difference.insert(.name)
        }
        
        if currentCopy?.id != otherCopy?.id {
            difference.insert(.id)
        }
        
        currentCopy = nil
        otherCopy = nil
        return difference
    }
}

// usage
let configOne = Config(name: "HEssam", id: UUID())
let configTwo = Config(name: "Alfred", id: UUID())

let differences = configOne.computeDifference(from: configTwo)
```

## Error Handling

The `DiffableMacroError` enum provides detailed error cases to help developers debug issues when applying the macro.

### Error Cases

#### shouldBeClassOrStructOrEnum:
- The macro is applied to an unsupported type. Only class, struct, or enum types are supported.

#### shouldConformToEquatableProtocol:
- The type does not conform to Equatable, which is required for the macro to function.

## Contributing
We welcome contributions! Feel free to submit a pull request or report an issue.

## License

Please check [LICENSE](LICENSE) for details.