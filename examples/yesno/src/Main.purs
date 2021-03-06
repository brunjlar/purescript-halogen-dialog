module Main where

import Control.Alternative
import Data.Either (Either (..))
import Data.Maybe (Maybe (..))
import Data.Tuple (Tuple (..))
import Halogen (runUI)
import Halogen.Component (Component(), component)
import Halogen.Dialog.YesNo (YesNo (..), yesNo, renderYesNo)
import Halogen.Dialog.HTML (Render (), renderMS)
import Halogen.Dialog.Signal (MS (), toMS')
import Halogen.Dialog.Utils (appendToBody)
import Halogen.Signal (SF1(), stateful)

import qualified Halogen.HTML as H
import qualified Halogen.HTML.Attributes as A
import qualified Halogen.HTML.Events as E
import qualified Halogen.Themes.Bootstrap3 as B
  
-- | The master output.
data MasterOutput = NotLaunched | Launched

-- | The master input.
data MasterInput = OrderLaunch | CancelOrder | Launch

-- | The master signal.
master :: SF1 MasterInput MasterOutput
master = stateful NotLaunched update where
    update :: MasterOutput -> MasterInput -> MasterOutput
    update NotLaunched Launch = Launched
    update x _ = x

-- | The master-slave signal.
ms :: SF1 (Either MasterInput (Maybe YesNo)) (MS MasterOutput Unit)
ms = toMS' master yesNo f g where

    f :: MasterInput -> MasterOutput -> Maybe Unit
    f OrderLaunch NotLaunched = Just unit
    f _ _ = Nothing

    g :: YesNo -> MasterInput
    g Yes = Launch
    g No  = CancelOrder
    
-- | Renders the master signal.
renderMaster :: Render MasterInput MasterOutput
renderMaster s = case s of
    NotLaunched -> H.div [A.class_ B.container] [headline, button]
    Launched -> H.div [A.class_ B.container] [headline, launched] where
        headline = H.h1_ [H.text "PureScript Halogen Yes/No Dialog"]
        button = H.button
            [ A.classes [B.btn, B.btnDanger, B.btnLg ]
            , E.onclick $ E.input \_ -> OrderLaunch
            ]
            [ H.text "Launch Missiles!" ]
        launched = H.p
            [ A.class_ B.lead ]
            [ H.text "Missiles launched!" ]

ui :: forall p m. (Alternative m) => Component p m (Either MasterInput (Maybe YesNo)) (Either MasterInput (Maybe YesNo))
ui = component (render <$> ms) where
    render :: Render (Either MasterInput (Maybe YesNo)) (MS MasterOutput Unit)
    render = renderMS renderMaster (renderYesNo "Are you sure?")
    
-- | The main method of this example.
main = do
  Tuple node _ <- runUI ui
  appendToBody node