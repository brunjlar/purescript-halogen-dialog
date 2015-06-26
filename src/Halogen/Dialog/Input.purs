-- | This module defines an extended dialog (slave) signal for entering strings.
module Halogen.Dialog.Input
    ( input
    , renderInput
    ) where
     
import Data.Either
import Data.Maybe
import Data.StrMap (fromList, singleton)
import Data.Tuple
import Halogen.Dialog.HTML
import Halogen.Dialog.Signal
import Halogen.Signal (SF1(), stateful)
      
import qualified Halogen.HTML as H
import qualified Halogen.HTML.Attributes as A
import qualified Halogen.HTML.Events as E
import qualified Halogen.HTML.Events.Forms as F

-- | The extended input dialog signal.
input :: ExtSF (Either String Boolean) String String (Maybe String)
input = ExtSF
    { signal : stateful "" update
    , input  : Left
    , output : output
    } where
    
    update :: String -> Either String Boolean -> String
    update _ (Left s) = s
    update s _ = s
    
    output :: Either String Boolean -> String -> Maybe (Maybe String)
    output (Left _) _      = Nothing
    output (Right true) s  = Just (Just s)
    output (Right false) _ = Just Nothing
    
-- | Renders the input dialog.
renderInput :: String -> Render (Either String Boolean) String
renderInput text s = H.div
    [ A.style (A.styles $ fromList
        [ Tuple "width" "150px"
        , Tuple "height" "100px"
        , Tuple "padding" "10px"
        ])]
    [ H.p_ [H.text text]
    , H.input
        [ F.onValueChanged (E.input Left)
        , A.value s
        , A.style (A.styles $ singleton "margin-bottom" "10px")
        ]
        []
    , H.button [E.onclick $ E.input \_ -> Right true] [H.text "Okay"]
    , H.button [E.onclick $ E.input \_ -> Right false] [H.text "Cancel"]
    ]