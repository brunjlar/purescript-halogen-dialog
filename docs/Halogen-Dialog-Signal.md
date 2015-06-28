# Module Documentation

## Module Halogen.Dialog.Signal


The "pure" part of the library. It defines extended signals and a way to combine them to master-slave signals.

#### `ExtSF`

``` purescript
newtype ExtSF i o i' o'
  = ExtSF { output :: i -> o -> Maybe o', input :: i' -> i, signal :: SF1 i o }
```

`ExtSF` is the type of "extended" signals, where a usual signal is extended by information on when and how to "make an external call".
Such an extended signal is a (wrapped) record, consisting of a normal signal `SF1 i o`,
an `input` function, which transforms an external input of type `i'` into a "normal" input of type `i`,
and an `output` function. This `output` function determines if, based on input and `head` (of type `o`), an external call should be made, and if so,
which external output of type `o'` should be used to make that call.

#### `MS`

``` purescript
newtype MS mo so
  = MS (Tuple mo (Maybe so))
```

`MS` is the output type for a master-slave signal, where `mo` is the master signal output and `so'` is the slave signal output.

#### `runMS`

``` purescript
runMS :: forall mo so. MS mo so -> Tuple mo (Maybe so)
```

Unwraps an `MS` value.

#### `step`

``` purescript
step :: forall i o. i -> SF1 i o -> SF1 i o
```

Advances a signal by one step.

#### `toMS`

``` purescript
toMS :: forall mi mo mi' mo' si so si' so'. ExtSF mi mo mi' mo' -> ExtSF si so si' so' -> (mo' -> si') -> (so' -> mi') -> SF1 (Either mi si) (MS mo so)
```

Combines a master and a slave signal.

#### `toMS'`

``` purescript
toMS' :: forall mi mo si so si' so'. SF1 mi mo -> ExtSF si so si' so' -> (mi -> mo -> Maybe si') -> (so' -> mi) -> SF1 (Either mi si) (MS mo so)
```

A simplified version of `toMS`, where the master signal is not explicitly extended.

#### `profunctorExtSF`

``` purescript
instance profunctorExtSF :: Profunctor (ExtSF i o)
```


#### `bifunctorMS`

``` purescript
instance bifunctorMS :: Bifunctor MS
```




