/// A macro that marks a class, struct or enum for automatic generation of diffable functionality.
///
/// The `@Diffable` macro is used to enable the identification of differences between two instances of the same type.
/// It scans for properties within the type and generates the required functionality to compute their differences.
///
/// ### Example
/// ```swift
/// @Diffable
/// struct User {
///     let id: UUID
///     var name: String
///     var age: Int
/// }
///
/// // Automatically generates functionality to compute differences, such as:
/// // - Comparing two `User` instances
/// // - Returning only the properties that have changed
/// ```
///
@attached(member, names: arbitrary)
public macro Diffable() = #externalMacro(
    module: "DiffableMacros",
    type: "DiffableMacro"
)
