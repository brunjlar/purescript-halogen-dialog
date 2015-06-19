# Module Documentation

## Module Halogen.Dialog.YesNo


This module defines an extended dialog (slave) signal for posing yes-no questions.

#### `YesNo`

``` purescript
data YesNo
  = Yes 
  | No 
  | Init 
```

The input type for the extended yes-no dialog signal.

#### `yesNo`

``` purescript
yesNo :: ExtSF YesNo Unit Boolean
```

The extended yes-no dialog signal.

#### `renderYesNo`

``` purescript
renderYesNo :: String -> Render YesNo Unit
```

Renders the yes-no signal.



