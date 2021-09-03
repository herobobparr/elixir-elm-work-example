module Page.Login exposing (..)

import Html exposing (Html)
import Msgs exposing (Msg)
import Model exposing (Model)
import Auth.Login


view : Model -> Html Msg
view model = Auth.Login.view model
