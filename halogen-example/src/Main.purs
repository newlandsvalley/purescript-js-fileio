module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Component (component, Message(..)) as FI
import Halogen.Aff as HA
import Halogen.VDom.Driver (runUI)
import Halogen (liftEffect)
import Halogen.Subscription as HS
import Data.MediaType (MediaType(..))
import DOM.HTML.Indexed.InputAcceptType (mediaType)
import Data.Maybe (Maybe(..))

main :: Effect Unit
main = HA.runHalogenAff
  let
    ctx = { componentId : "abcinput"
          , isBinary : false
          , prompt : "load a .txt file:"
          , accept :  mediaType (MediaType ".txt")
          }

  in do
    body <- HA.awaitBody
    io <- runUI (FI.component ctx ) unit body    
    
    liftEffect $ HS.subscribe io.messages \msg -> do
      case msg of 
        FI.FileLoaded filespec -> do
          liftEffect $ log $ "File was loaded: " <> filespec.name
          pure Nothing
    
