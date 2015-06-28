-- | This module helps rendering master-slave signals.
module Halogen.Dialog.HTML
    ( Render ()
    , renderDialog
    , renderMS
    ) where
   
import Control.Alternative
import Data.Either
import Data.Maybe
import Data.StrMap (singleton, fromList)
import Data.Tuple
import Halogen.Dialog.Signal
import Halogen.Dialog.Utils (filterJust)  
  
import qualified Halogen.HTML as H
import qualified Halogen.HTML.Attributes as A
import qualified Halogen.HTML.Events as E
import qualified Halogen.Themes.Bootstrap3 as B
    
-- | Type synonym for rendering functions.
type Render i o = forall p m. (Alternative m) => o -> H.HTML p (m i)

-- | A convenience function for easy rendering of modal dialogs, using Bootstrap classes.
-- | The arguments are optional header elements, body elements and optional footer elements, respectively.
renderDialog :: forall p m i. (Alternative m) => Maybe [H.HTML p (m i)] -> [H.HTML p (m i)] -> Maybe [H.HTML p (m i)] -> H.HTML p (m i)
renderDialog h b f = div B.modalContent sections where
    
    div :: A.ClassName -> [H.HTML p (m i)] -> H.HTML p (m i)
    div n xs = H.div [ A.class_ n ] xs
    
    sections :: [H.HTML p (m i)]
    sections = filterJust [(div B.modalHeader) <$> h, Just $ div B.modalBody b, (div B.modalFooter) <$> f]
    
-- | Renders a master-slave signal.
renderMS :: forall i o i' o'. Render i o -> Render i' o' -> Render (Either i i') (MS o o')
renderMS r r' = render where
    render :: Render (Either i i') (MS o o')
    render (MS (Tuple x Nothing))  = renderMaster x
    render (MS (Tuple x (Just y))) = H.div_
        [ H.div
            [ A.style (A.styles $ singleton "opacity" "0.99") ] 
            [ renderMaster x ]
        , H.div
            [ A.style (A.styles $ fromList
                [ Tuple "opacity" "0.5"
                , Tuple "position" "fixed"
                , Tuple "width" "100%"
                , Tuple "height" "100%"
                , Tuple "left" "0px"
                , Tuple "top" "0px"
                , Tuple "background-color" "black"
                ])]
            []
        , H.div
            [ A.style (A.styles $ fromList
                [ Tuple "opacity" "0.99"
                , Tuple "position" "fixed"
                , Tuple "left" "30px"
                , Tuple "top" "30px"
                , Tuple "background-color" "white"
                ])]
            [ renderSlave y ]
        ]
    
    renderMaster :: Render (Either i i') o
    renderMaster x = (Left <$>) <$> r x
    
    renderSlave :: Render (Either i i') o'
    renderSlave y = (Right <$>) <$> r' y