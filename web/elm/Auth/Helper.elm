module Auth.Helper exposing (..)


import Navigation exposing (newUrl)
import Msgs exposing (Msg)
import Model exposing (Model)
import Routing exposing (loginPath)


redirectOnAnonymous : Model -> (Model -> Cmd Msg) -> Cmd Msg
redirectOnAnonymous model commandFunc =
    case model.auth of
       Just auth ->
           commandFunc model
       Nothing ->
           newUrl loginPath
