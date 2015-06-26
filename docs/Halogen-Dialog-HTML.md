# Module Documentation

## Module Halogen.Dialog.HTML


This module helps rendering master-slave signals.

#### `Render`

``` purescript
type Render i o = forall p m. (Alternative m) => o -> H.HTML p (m i)
```

Type synonym for rendering functions.

#### `renderMS`

``` purescript
renderMS :: forall i o i' o'. Render i o -> Render i' o' -> Render (Either i i') (MS o o')
```

Renders a master-slave signal.



