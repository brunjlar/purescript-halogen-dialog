# Module Documentation

## Module Halogen.Dialog.Input


This module defines an extended dialog (slave) signal for entering strings.

#### `input`

``` purescript
input :: ExtSF (Either String Boolean) String String (Maybe String)
```

The extended input dialog signal.

#### `renderInput`

``` purescript
renderInput :: String -> Render (Either String Boolean) String
```

Renders the input dialog.



