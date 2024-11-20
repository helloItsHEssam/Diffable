/// A macro that marks a class, struct, or actor for automatic setter generation by applying
/// [@BuildableTracked](<doc:BuildableMacro/BuildableTracked(name:forceEscaping:)>) to properties.
///
/// It scans for settable properties and applies [`@Buildable`](<doc:BuildableMacro/Buildable()>) to them, unless marked
/// with [`@BuildableIgnored`](<doc:BuildableMacro/BuildableIgnored()>).
///
/// Example:
/// ```swift
/// @Buildable
/// struct User {
///     @BuildableIgnored
///     let id: UUID
///     var name: String
/// }
/// // Automatically adds @BuildableTracked to 'name' but not to 'id'.
/// ```
///
/// - Note: This macro is an entry point for the Buildable functionality.
@attached(member, names: arbitrary)
public macro Diffable() = #externalMacro(
    module: "DiffableMacros",
    type: "DiffableMacro"
)
