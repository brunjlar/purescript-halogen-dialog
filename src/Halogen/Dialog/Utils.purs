-- | Contains utilities.
module Halogen.Dialog.Utils
    ( appendToBody
    , undefined
    , filterJust
    ) where

import Control.Monad.Eff (Eff())
import Data.Foldable (foldr)
import Data.Maybe (Maybe (), maybe)
import DOM (Node(), DOM())
    
-- | Appends an element to the body of the page.
foreign import appendToBody
  "function appendToBody(node) {\
  \  return function() {\
  \    document.body.appendChild(node);\
  \  };\
  \}" :: forall eff. Node -> Eff (dom :: DOM | eff) Node

-- | A convenience "value" of any type (mostly used for development).
foreign import undefined :: forall a. a

-- | Given a list of `Maybe`'s, `filterJust` discards all `Nothing`'s and unwraps the `Just`'s.
filterJust :: forall a. [Maybe a] -> [a]
filterJust = foldr (maybe id (:)) []
    