{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "js-fileio-halogen"
, dependencies = [ "console"
                 , "effect"
                 , "js-fileio"
                 , "halogen"
                 , "halogen-css"  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
