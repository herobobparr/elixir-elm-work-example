module Page.Main exposing (..)

import Html exposing (Html)
import Msgs exposing (Msg)
import Model exposing (Model)
import Auth.Login
import Bank.List


view : Model -> Html Msg
view model =
    case model.auth of
        Just auth ->
            Bank.List.view model
        Nothing ->
            Auth.Login.view model
