-- | This module defines an extended dialog (slave) signal for posing yes-no questions.
module Halogen.Dialog.YesNo
    ( YesNo (..)
    , yesNo
    , renderYesNo
    ) where
     
import Data.Maybe
import Data.StrMap (fromList)
import Data.Tuple
import Halogen.Dialog.HTML
import Halogen.Dialog.Signal
import Halogen.Signal (SF1(), stateful)
      
import qualified Halogen.HTML as H
import qualified Halogen.HTML.Attributes as A
import qualified Halogen.HTML.Events as E
    
-- | The input type for the extended yes-no dialog signal.
data YesNo = Yes | No

-- | The extended yes-no dialog signal.
yesNo :: ExtSF (Maybe YesNo) Unit Unit YesNo
yesNo = ExtSF 
    { signal : stateful unit \_ _ -> unit
    , input  : \_ -> Nothing
    , output : \x _ -> x
    }
    
-- | Renders the yes-no dialog.
renderYesNo :: String -> Render (Maybe YesNo) Unit
renderYesNo question _ = H.div
    [ A.style (A.styles $ fromList
        [ Tuple "width" "150px"
        , Tuple "height" "80px"
        , Tuple "padding" "10px"
        ])]
    [ H.p_ [H.text question]
    , H.button [E.onclick $ E.input \_ -> Just Yes] [H.text "Yes"]
    , H.button [E.onclick $ E.input \_ -> Just No] [H.text "No"]
    ]