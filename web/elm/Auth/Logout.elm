module Auth.Logout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Model exposing (Model)
import Msgs exposing (Msg)


view : Model -> Html Msg
view model =
    div []
        [ h4 [] [ text "You've logged out" ]
        , p [] [ text "Hope we will see you again" ]
        ]
