module Page.Logout exposing (..)

import Html exposing (Html)
import Model exposing (Model)
import Msgs exposing (Msg)
import Auth.Logout


view : Model -> Html Msg
view model = Auth.Logout.view model