module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Model exposing (Model, Route(..))
import Msgs exposing (Msg)
import Common.Navigation
import Page.About
import Page.Login
import Page.Logout
import Page.Main
import Page.BankDetails


view : Model -> Html Msg
view model =
    div [ ]
        [
          Common.Navigation.view model
        , div [ class "container" ]
              [ page model ]
        ]


page: Model -> Html Msg
page model =
    case model.route of
        MainRoute ->
            Page.Main.view model
        LoginRoute ->
            Page.Login.view model
        LogoutRoute ->
            Page.Logout.view model
        AboutRoute ->
            Page.About.view model
        BankDetailsRoute bankSlug ->
            Page.BankDetails.view model bankSlug
        NotFoundRoute ->
            notFoundView model


notFoundView : Model -> Html Msg
notFoundView model =
    div []
        [ text "Page Not Found" ]
