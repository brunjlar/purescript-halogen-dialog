# Module Documentation

## Module Halogen.Dialog.Signal


The "pure" part of the library. It defines extended signals and a way to combine them to master-slave signals.

#### `ExtSF`

``` purescript
type ExtSF i o e = { external :: i -> o -> Maybe e, signal :: SF1 i o }
```

`ExtSF` is the type of "extended" signal functions, where a usual signal function is extended by information on when and how to "make an external call".

#### `MS`

``` purescript
newtype MS o o'
  = MS (Tuple o (Maybe o'))
```

`MS` is the output type for a master-slave signal, where `o` is the master signal output and `o'` is the slave signal output.

#### `runMS`

``` purescript
runMS :: forall o o'. MS o o' -> Tuple o (Maybe o')
```

Unwraps an `MS` value.

#### `toMS`

``` purescript
toMS :: forall i o e i' o' e'. ExtSF i o e -> ExtSF i' o' e' -> (e -> i') -> (e' -> i) -> SF1 (Either i i') (MS o o')
```

Combines a master and a slave signal.

#### `bifunctorMS`

``` purescript
instance bifunctorMS :: Bifunctor MS
```




