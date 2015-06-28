# Module Documentation

## Module Halogen.Dialog.HTML


This module helps rendering master-slave signals.

#### `Render`

``` purescript
type Render i o = forall p m. (Alternative m) => o -> H.HTML p (m i)
```

Type synonym for rendering functions.

#### `renderDialog`

``` purescript
renderDialog :: forall p m i. (Alternative m) => Maybe [H.HTML p (m i)] -> [H.HTML p (m i)] -> Maybe [H.HTML p (m i)] -> H.HTML p (m i)
```

A convenience function for easy rendering of modal dialogs, using Bootstrap classes.
The arguments are optional header elements, body elements and optional footer elements, respectively.

#### `renderMS`

``` purescript
renderMS :: forall i o i' o'. Render i o -> Render i' o' -> Render (Either i i') (MS o o')
```

Renders a master-slave signal.



