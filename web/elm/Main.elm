module Main exposing (..)

import Navigation exposing (Location)
import Model exposing (Model, initialModel)
import Msgs exposing (Msg)
import Update exposing (update)
import Subscriptions exposing (subscriptions)
import Views exposing (view)
import Routing exposing (parseLocation)
import Update exposing (sendCommandOnRouteChange)



init : Location -> (Model, Cmd Msg)
init location =
    let
        currentRoute = parseLocation location
        model = initialModel currentRoute
    in
        ( model, sendCommandOnRouteChange model currentRoute )


-- MAIN
main = Navigation.program Msgs.OnLocationChange
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
