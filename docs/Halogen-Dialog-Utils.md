# Module Documentation

## Module Halogen.Dialog.Utils


Contains utilities.

#### `appendToBody`

``` purescript
appendToBody :: forall eff. Node -> Eff (dom :: DOM | eff) Node
```

Appends an element to the body of the page.

#### `undefined`

``` purescript
undefined :: forall a. a
```

A convenience "value" of any type (mostly used for development).

#### `filterJust`

``` purescript
filterJust :: forall a. [Maybe a] -> [a]
```

Given a list of `Maybe`'s, `filterJust` discards all `Nothing`'s and unwraps the `Just`'s.



