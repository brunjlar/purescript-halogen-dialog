-- | The "pure" part of the library. It defines extended signals and a way to combine them to master-slave signals.
module Halogen.Dialog.Signal
    ( ExtSF ()
    , MS (..)
    , runMS
    , toMS
    ) where

import Data.Bifunctor
import Data.Either
import Data.Maybe
import Data.Tuple
import Halogen.Signal

-- | `ExtSF` is the type of "extended" signal functions, where a usual signal function is extended by information on when and how to "make an external call".
type ExtSF i o e =
    { signal     :: SF1 i o
    , external   :: i -> o -> Maybe e
    }

-- | `MS` is the output type for a master-slave signal, where `o` is the master signal output and `o'` is the slave signal output.
newtype MS o o' = MS (Tuple o (Maybe o'))

-- | Unwraps an `MS` value.
runMS :: forall o o'. MS o o' -> Tuple o (Maybe o')
runMS (MS x) = x

-- | Combines a master and a slave signal.
toMS :: forall i o e i' o' e'. ExtSF i o e -> ExtSF i' o' e' -> (e -> i') -> (e' -> i) -> SF1 (Either i i') (MS o o')
toMS m s f g = ((bimap head head) <$>) machine where

    machine :: SF1 (Either i i') (MS (SF1 i o) (SF1 i' o'))
    machine = stateful init update
    
    init :: MS (SF1 i o) (SF1 i' o')
    init = MS (Tuple m.signal Nothing)
    
    update :: MS (SF1 i o) (SF1 i' o') -> Either i i' -> MS (SF1 i o) (SF1 i' o')
    update (MS (Tuple x y)) i = MS $ update' x y i
    
    update' :: SF1 i o -> Maybe (SF1 i' o') -> Either i i' -> Tuple (SF1 i o) (Maybe (SF1 i' o'))
    update' x y (Left i)         = case m.external i (head x) of
        Nothing -> Tuple (step i x) y
        Just e  -> Tuple x (Just $ step (f e) s.signal)
    update' x Nothing (Right _)  = Tuple x Nothing
    update' x (Just y) (Right j) = case s.external j (head y) of
        Nothing -> Tuple x (Just $ step j y)
        Just e  -> Tuple (step (g e) x) Nothing
        
    step :: forall i o. i -> SF1 i o -> SF1 i o
    step i x = runSF (tail x) i
    
instance bifunctorMS :: Bifunctor MS where
    bimap f g = MS <<< bimap f (g <$>) <<< runMS