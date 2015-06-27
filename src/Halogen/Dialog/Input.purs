-- | This module defines an extended dialog (slave) signal for entering strings.
module Halogen.Dialog.Input
    ( input
    , renderInput
    ) where
     
import Data.Either
import Data.Maybe
import Data.Tuple
import Halogen.Dialog.HTML
import Halogen.Dialog.Signal
import Halogen.Signal (SF1(), stateful)
      
import qualified Halogen.HTML as H
import qualified Halogen.HTML.Attributes as A
import qualified Halogen.HTML.Events as E
import qualified Halogen.HTML.Events.Forms as F
import qualified Halogen.Themes.Bootstrap3 as B

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
renderInput text s = H.div [ A.class_ B.modalContent ]
    [ H.div [ A.class_ B.modalBody ]
        [ H.div [ A.class_ B.formGroup ]
            [ H.label_ [ H.text text ]
            , H.input
                [ A.type_ "text"
                , A.class_ B.formControl 
                , F.onValueChanged (E.input Left)
                , A.value s
                ]
                []
            ]
        ]
    , H.div [ A.class_ B.modalFooter ]
        [ H.div [ A.class_ B.btnGroup ]
            [ H.button
                [ A.classes [B.btn, B.btnPrimary]
                , E.onclick $ E.input \_ -> Right true
                ]
                [ H.text "Okay" ]
            , H.button
                [ A.classes [B.btn, B.btnDefault]
                , E.onclick $ E.input \_ -> Right false
                ]
                [ H.text "Cancel" ]
            ]
        ]
    ]