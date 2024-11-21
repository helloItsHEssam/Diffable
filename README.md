# Diffable Macro  

## Overview  

The `@Diffable` macro provides an efficient way to calculate differences between two instances of a type by automatically generating code to compare properties. It ensures that you only focus on the high-level design of your types while leveraging the macro for advanced functionality.  

To use the `@Diffable` macro, the target type must:  
1. Be a `class`, `struct`, or `enum`.  
2. Conform to the `Equatable` protocol.  

The macro will generate an optimized implementation of difference computation for all `Equatable` properties in your type.  

When applied, the macro generates a computeDifference method that calculates the difference between two Config instances, returning a strongly-typed result indicating the changed properties.

## How to using  

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

## Sample Using Diffable

```swift
/// A custom UIView that displays a person's name and age.
/// This view uses a diffable configuration to detect and apply changes to its properties efficiently.
final class PersonView: UIView {
    
    // MARK: - UI Elements
    
    /// Label to display the person's name.
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    /// Label to display the person's age.
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    // MARK: - Properties
    
    /// The current configuration of the view.
    private var configuration: Configuration
    
    // MARK: - Initializers
    
    /// Initializes the view with the given configuration.
    ///
    /// - Parameter configuration: The initial configuration of the view.
    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(frame: .zero)
    }
    
    @available(*, unavailable, message: "init(frame:) is not supported. Use init(configuration:) instead.")
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    @available(*, unavailable, message: "init(coder:) is not supported. Use init(configuration:) instead.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration Update
    
    /// Updates the view's configuration and applies changes to the UI.
    ///
    /// - Parameter configuration: The new configuration to apply.
    func updateConfiguration(to configuration: Configuration) {
        // Compute the differences between the old and new configurations.
        let differences = self.configuration.computeDifference(from: configuration)
        
        // Iterate through potential differences and update the UI for changed properties.
        for i in 0 ..< Int.bitWidth {
            let bit = 1 << i
            let difference = Configuration.Difference(rawValue: bit)
            
            if differences.contains(difference) {
                switch difference {
                case .age:
                    // Update the age label if the age has changed.
                    self.ageLabel.text = "\(configuration.age)"
                    
                case .name:
                    // Update the name label if the name has changed.
                    self.nameLabel.text = configuration.name
                    
                default:
                    break
                }
            }
        }
        
        // Update the stored configuration.
        self.configuration = configuration
    }
    
    // MARK: - Configuration Struct
    
    /// Represents the configuration of the `PersonView`.
    /// This struct uses the `@Diffable` macro to enable efficient change detection.
    @Diffable
    struct Configuration: Equatable {
        /// The person's name.
        let name: String
        /// The person's age.
        let age: Int
    }
}
```





## Error Handling

The `DiffableMacroError` enum provides detailed error cases to help developers debug issues when applying the macro.

### Error Cases

#### shouldBeClassOrStructOrEnum:
- The macro is applied to an unsupported type. Only class, struct, or enum types are supported.

#### shouldConformToEquatableProtocol:
- The type does not conform to Equatable, which is required for the macro to function.

## Contributing
We warmly welcome contributions to the BuildableMacro project! Whether you're fixing bugs, improving the documentation, or adding new features, your help is appreciated. Here’s how you can contribute:

1. **Fork the Repository**: Start by forking the repository to your own GitHub account.
2. **Create a Branch**: Make your changes in a new branch.
3. **Make Your Changes**: Whether it's a new feature or a bug fix, your contributions make a difference.
4. **Write Tests**: Ensure your changes are working as expected.
5. **Submit a Pull Request**: Once you're satisfied, submit a pull request for review.

To give clarity of what is expected of our members, we have adopted the code of conduct defined by the Contributor Covenant. This document is used across many open source communities. For more, see the [Code of Conduct](CODE_OF_CONDUCT.md).

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)

## License

Please check [LICENSE](LICENSE) for details.