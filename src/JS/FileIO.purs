module JS.FileIO
  ( Filespec
  , loadTextFile
  , loadBinaryFileAsText
  , saveTextFile ) where

import Prelude (Unit, (<<<))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)

-- | the result of a file load
type Filespec = {
    contents :: String
  , name :: String
  }

foreign import loadTextFileImpl
  :: String -> EffectFnAff Filespec

-- | load a text file from a DOM element with the supplied id
loadTextFile :: String -> Aff Filespec
loadTextFile =
  fromEffectFnAff <<< loadTextFileImpl

foreign import loadBinaryFileAsTextImpl
    :: String -> EffectFnAff Filespec

-- | load a binary file from a DOM element with the supplied id
-- | and tunnel it as a binary string
loadBinaryFileAsText :: String -> Aff Filespec
loadBinaryFileAsText =
  fromEffectFnAff <<< loadBinaryFileAsTextImpl

-- | save a text file
foreign import saveTextFile :: Filespec -> Effect Unit
