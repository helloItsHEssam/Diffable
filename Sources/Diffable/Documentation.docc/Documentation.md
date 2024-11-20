# ``Diffable``

A macro for computing differences between two instances of the same type.

## Overview

This macro is applied to types conforming to `Equatable` and tracks properties for changes unless explicitly ignored.

The @Diffable macro is designed to generate a method for computing differences between instances of the same type. However, it requires the type to be either a class, struct, or enum, and the type must conform to the Equatable protocol. Violating these requirements triggers a specific error case in DiffableMacroError.

The DiffableMacroError enum provides error cases to identify invalid usage of the @Diffable macro. Each case explains the reason for the error, such as applying the macro to an unsupported type or a type that does not conform to the Equatable protocol.

## Topics

- <doc:Diffable/Diffable()>
