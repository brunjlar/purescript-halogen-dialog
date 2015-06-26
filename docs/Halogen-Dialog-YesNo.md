# Module Documentation

## Module Halogen.Dialog.YesNo


This module defines an extended dialog (slave) signal for posing yes-no questions.

#### `YesNo`

``` purescript
data YesNo
  = Yes 
  | No 
```

The input type for the extended yes-no dialog signal.

#### `yesNo`

``` purescript
yesNo :: ExtSF (Maybe YesNo) Unit Unit YesNo
```

The extended yes-no dialog signal.

#### `renderYesNo`

``` purescript
renderYesNo :: String -> Render (Maybe YesNo) Unit
```

Renders the yes-no dialog.



