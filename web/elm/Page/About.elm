module Page.About exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, target)
import Model exposing (Model)
import Msgs exposing (Msg)

view : Model -> Html Msg
view model =
    div []
        [ h4 [] [ text "About" ]
        , div []
              [ p [] [ text "This project has been built with Elixir and Phoenix" ]
              , strong [] [ text "Source code: " ]
              , a [ href "https://github.com/Zapix/usd2rur"
                  , target "_blank"
                  ]
                  [ text "https://github.com/Zapix/usd2rur" ]
              ]
        ]