module Main where

import CSS.TextAlign (center, textAlign)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Exception (EXCEPTION)
import Control.Monad.Eff.Class (liftEff)
import Data.Maybe (Maybe(..))
import Prelude (Unit, bind, discard, const, pure, ($), (<>))
import Pux (EffModel, noEffects, start)
import Pux.DOM.Events (onChange, onClick)
import Pux.DOM.HTML (HTML)
import Pux.DOM.HTML.Attributes (style)
import Pux.Renderer.React (renderToDOM)
import Text.Smolder.HTML (div, h1, p, input, button)
import Text.Smolder.HTML.Attributes (type', id, accept, className)
import Text.Smolder.Markup (Attribute, text, (#!), (!))
import Signal.Channel (CHANNEL)
import JS.FileIO

-- WARNING PS v 0.11.7 

data Event
  = NoOp
  | RequestTextFileUpload
  | RequestBinaryFileUpload
  | SaveTextFile
  | FileLoaded Filespec

type State =
  { filespec :: Maybe Filespec }

initialState :: State
initialState = {
    filespec : Nothing
  }

foldp :: Event -> State -> EffModel State Event (fileio :: FILEIO)
foldp NoOp state =  noEffects $ state
foldp RequestTextFileUpload state =
 { state: state
   , effects:
     [ do
         filespec <- loadTextFile "textinput"
         pure $ Just (FileLoaded filespec)
     ]
  }
foldp RequestBinaryFileUpload state =
 { state: state
   , effects:
     [ do
         filespec <- loadBinaryFileAsText "binaryinput"
         pure $ Just (FileLoaded filespec)
     ]
  }
foldp (FileLoaded filespec) state =
   noEffects $ saveFilespec filespec state
foldp SaveTextFile state =
   { state: state
     , effects:
       [ do
           let
             fsp = { name: "test.txt", contents : "sample content"} :: Filespec
           res <- liftEff $ saveTextFile fsp
           pure $ (Just NoOp)
       ]
    }
saveFilespec :: Filespec -> State -> State
saveFilespec filespec state =
   state { filespec = Just filespec }

viewFile :: State -> String
viewFile state =
  case state.filespec of
    Nothing ->
      ""
    Just fs ->
      fs.name <> " loaded OK"

view :: State -> HTML Event
view state =
   div  do
     h1 ! centreStyle $ text "test file input"
     p $ text "load a text file"
     div do
       input ! type' "file" ! id "textinput" ! accept ".abc, .txt"
         #! onChange (const RequestTextFileUpload)
     p $ text "load a binary file as text"
     div do
       input ! type' "file" ! id "binaryinput" ! accept ".midi"
         #! onChange (const RequestBinaryFileUpload)
     p $ text $ viewFile state
     p $ text "save a sample file (test.txt)"
     div do
       button ! className "hoverable"
          #! onClick (const $ SaveTextFile) $ text "save"

centreStyle :: Attribute
centreStyle =
  style do
    textAlign center

main :: Eff (channel :: CHANNEL, exception :: EXCEPTION, fileio :: FILEIO ) Unit
main = do
  app <- start
    { initialState: initialState
    , view
    , foldp
    , inputs: []
    }

  renderToDOM "#app" app.markup app.input
