
@attached(member, names: arbitrary)
public macro Diffable() = #externalMacro(
    module: "DiffableMacros",
    type: "DiffableMacro"
)
