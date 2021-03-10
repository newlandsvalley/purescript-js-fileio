module Component where

import Prelude

import Data.Maybe (Maybe(..))

import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.HTML.Core (ClassName(..))
import DOM.HTML.Indexed.InputAcceptType (InputAcceptType)
import JS.FileIO (Filespec, loadTextFile, loadBinaryFileAsText)
import FileInputComponent.Dom (resetInputValue)

-- | A simple file input control that wraps JS.FileIO
-- | Whether or not it is enabled may be set externally via a query

type Slot = H.Slot Query Message

type Context = {
    componentId :: String     -- the component id
  , isBinary    :: Boolean    -- does it handle binary as text or just simple text
  , prompt      :: String     -- the user prompt
  , accept      :: InputAcceptType  -- the accepted media type(s)
  }

data Action = LoadFile

data Query a =
  UpdateEnabled Boolean a

data Message = FileLoaded Filespec

type State =
  { mfsp :: Maybe Filespec
  , isEnabled :: Boolean
  }

component :: ∀ i m. MonadAff m => Context -> H.Component Query i Message m
component ctx =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval
        { handleAction = handleAction
        , handleQuery = handleQuery
        , initialize = Nothing
        , finalize = Nothing
        }
    }
  where

  initialState :: i -> State
  initialState _ =
    { mfsp: Nothing
    , isEnabled : true
    }

  render :: State -> H.ComponentHTML Action () m
  render state =
    HH.span
      [ HP.class_ $ ClassName "fileInput" ]
      [ -- the label is a hack to allow styling of file input which is
        -- otherwise impossible - see https://stackoverflow.com/questions/572768/styling-an-input-type-file-button
        HH.label
             [ HP.for ctx.componentId
             , HP.class_ $ ClassName "hoverable fileInputLabel"
             -- , HP.class_ $ ClassName "fileInputLabel"
             ]
             [ HH.text ctx.prompt ]
        -- we set the style to display none so that the label acts as a button
      , HH.input
          [ -- HE.onChange (HE.input_ LoadFile)
            HE.onChange \_ -> LoadFile
          , HP.type_ HP.InputFile
          , HP.class_ $ ClassName "noDisplay"
          , HP.id  ctx.componentId
          , HP.accept ctx.accept
          , HP.enabled state.isEnabled
          ]
       , renderContents state
      ]

  renderContents :: State -> H.ComponentHTML Action () m
  renderContents state =
    case state.mfsp of
      Nothing ->
        HH.text ""
      Just fsp ->
        HH.text fsp.contents

  handleAction ∷ Action → H.HalogenM State Action () Message m Unit
  handleAction = case _ of
    LoadFile -> do
      filespec <-
         if ctx.isBinary then
           H.liftAff $ loadBinaryFileAsText ctx.componentId
         else
           H.liftAff $ loadTextFile ctx.componentId
      _ <- H.modify (\state -> state { mfsp = Just filespec } )
      -- now reset the file input component value to allow repeat requests
      -- for the same file
      _ <- H.liftEffect $ resetInputValue ctx.componentId
      H.raise $ FileLoaded filespec

  handleQuery :: forall o a. Query a -> H.HalogenM State Action () o m (Maybe a)
  handleQuery = case _ of
    UpdateEnabled isEnabled next -> do
      _ <- H.modify (\state -> state {isEnabled = isEnabled})
      pure (Just next)

