-- | The "pure" part of the library. It defines extended signals and a way to combine them to master-slave signals.
module Halogen.Dialog.Signal
    ( ExtSF (..)
    , MS (..)
    , runMS
    , step
    , toMS
    , toMS'
    ) where

import Data.Bifunctor (Bifunctor, bimap)
import Data.Either
import Data.Maybe
import Data.Profunctor (Profunctor, dimap)
import Data.Tuple
import Halogen.Signal

import Halogen.Dialog.Utils (undefined)

-- | `ExtSF` is the type of "extended" signal functions, where a usual signal function is extended by information on when and how to "make an external call".
newtype ExtSF i o i' o'  = ExtSF
    { signal     :: SF1 i o
    , input      :: i' -> i
    , output     :: i -> o -> Maybe o'
    }
    
-- | `MS` is the output type for a master-slave signal, where `mo` is the master signal output and `so'` is the slave signal output.
newtype MS mo so = MS (Tuple mo (Maybe so))

-- | Unwraps an `MS` value.
runMS :: forall mo so. MS mo so -> Tuple mo (Maybe so)
runMS (MS x) = x

-- | Advances a signal by one step.
step :: forall i o. i -> SF1 i o -> SF1 i o
step i x = runSF (tail x) i

-- | Combines a master and a slave signal.
toMS :: forall mi mo mi' mo' si so si' so'. ExtSF mi mo mi' mo' -> ExtSF si so si' so' -> (mo' -> si') -> (so' -> mi') -> SF1 (Either mi si) (MS mo so)
toMS (ExtSF m) (ExtSF s) f g = ((bimap head head) <$>) machine where

    machine :: SF1 (Either mi si) (MS (SF1 mi mo) (SF1 si so))
    machine = stateful init update
    
    init :: MS (SF1 mi mo) (SF1 si so)
    init = MS (Tuple m.signal Nothing)
    
    update :: MS (SF1 mi mo) (SF1 si so) -> Either mi si -> MS (SF1 mi mo) (SF1 si so)
    update (MS (Tuple x y)) i = MS $ update' x y i
    
    update' :: SF1 mi mo -> Maybe (SF1 si so) -> Either mi si -> Tuple (SF1 mi mo) (Maybe (SF1 si so))
    update' x y (Left i)         = case m.output i (head x) of
        Nothing -> Tuple (step i x) y
        Just e  -> Tuple x (Just $ step (s.input $ f e) s.signal)
    update' x Nothing (Right _)  = Tuple x Nothing
    update' x (Just y) (Right j) = case s.output j (head y) of
        Nothing -> Tuple x (Just $ step j y)
        Just e  -> Tuple (step (m.input $ g e) x) Nothing
    
-- | A simplified version of `toMS`, where the master signal is not explicitly extended.
toMS' :: forall mi mo si so si' so'. SF1 mi mo -> ExtSF si so si' so' -> (mi -> mo -> Maybe si') -> (so' -> mi) -> SF1 (Either mi si) (MS mo so)
toMS' m s o = toMS m' s id where
    m' :: ExtSF mi mo mi si'
    m' = ExtSF { signal: m, input: id, output: o }
    
instance profunctorExtSF :: Profunctor (ExtSF i o) where
    dimap f g (ExtSF x) = ExtSF
        { signal: x.signal
        , input: x.input <<< f
        , output: \i o -> g <$> x.output i o
        }
    
instance bifunctorMS :: Bifunctor MS where
    bimap f g = MS <<< bimap f (g <$>) <<< runMS