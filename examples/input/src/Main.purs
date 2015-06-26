module Main where

import Control.Alternative
import Data.Either (Either (..))
import Data.Maybe (Maybe (..))
import Data.Tuple (Tuple (..))
import Halogen (runUI)
import Halogen.Component (Component(), component)
import Halogen.Dialog.Input (input, renderInput)
import Halogen.Dialog.HTML (Render (), renderMS)
import Halogen.Dialog.Signal (MS (), toMS')
import Halogen.Dialog.Utils (appendToBody)
import Halogen.Signal (SF1(), stateful)

import qualified Halogen.HTML as H
import qualified Halogen.HTML.Events as E

-- | The master input.
data MasterInput = OpenDialog | Name String | Idle

-- | The master signal.
master :: SF1 MasterInput (Maybe String)
master = stateful Nothing update where
    update :: Maybe String -> MasterInput -> Maybe String
    update _ (Name s) = Just s
    update x _ = x
    
-- | The master-slave signal.
ms :: SF1 (Either MasterInput (Either String Boolean)) (MS (Maybe String) String)
ms = toMS' master input f g where

    f :: MasterInput -> Maybe String -> Maybe String
    f OpenDialog Nothing  = Just ""
    f OpenDialog (Just s) = Just s
    f _ _ = Nothing

    g :: Maybe String -> MasterInput
    g Nothing = Idle
    g (Just s) = Name s
    
-- | Renders the master signal.
renderMaster :: Render MasterInput (Maybe String)
renderMaster s = H.div_ 
    [ H.h1_ [H.text "PureScript Halogen Input Dialog"]
    , H.p_ [H.text $ greeting s]
    , H.button [E.onclick $ E.input \_ -> OpenDialog] [H.text $ buttonText s]
    ] where
    
    greeting :: Maybe String -> String
    greeting Nothing = "I don't know your name!"
    greeting (Just s) = "Hello, " ++ s ++ "!"
    
    buttonText :: Maybe String -> String
    buttonText Nothing = "Enter Name"
    buttonText (Just _) = "Change Name"
    
ui :: forall p m. (Alternative m) => Component p m (Either MasterInput (Either String Boolean)) (Either MasterInput (Either String Boolean))
ui = component (render <$> ms) where
    render :: Render (Either MasterInput (Either String Boolean)) (MS (Maybe String) String)
    render = renderMS renderMaster (renderInput "Enter your name:")
    
-- | The main method of this example.
main = do
  Tuple node _ <- runUI ui
  appendToBody node