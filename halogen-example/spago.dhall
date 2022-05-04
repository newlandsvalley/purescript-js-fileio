let config = ../spago.dhall

in config // {
  sources = config.sources # [ "halogen-example/**/*.purs" ],
  dependencies = config.dependencies  # [ "console"
                                        , "dom-indexed"
                                        , "effect"
                                        , "maybe"
                                        , "media-types"
                                        , "halogen"
                                        , "halogen-subscriptions"
                                        ]
}

