module Bank.List exposing (..)


import Html exposing (..)
import Html.Attributes exposing (class, href)
import Msgs exposing (Msg)
import Model exposing (Model)
import Bank.Model exposing (BankModel, Bank)
import Routing exposing (bankDetailsPath)
import RemoteData

view : Model -> Html Msg
view model =
    div [ class "row" ]
        [ header
        , maybeBankList model.bank
        ]


header : Html Msg
header =
    div [ class "col s12"]
        [ h4 [] [ text "Banks List" ]
        ]


maybeBankList : BankModel -> Html Msg
maybeBankList bankModel =
    case bankModel.banks of
        RemoteData.NotAsked ->
            text "Loading..."
        RemoteData.Loading ->
            text "Loading..."
        RemoteData.Success banks ->
            bankList banks
        RemoteData.Failure error ->
            text "Can`t load list"


bankList : List Bank -> Html Msg
bankList banks =
    table [ class "bordered" ]
        [ thead []
            [ tr []
                 [ th [] [  text "Name" ]
                 ]
            ]
        , tbody [] (List.map bankRow banks)
        ]


bankRow : Bank -> Html Msg
bankRow bank =
    tr []
       [ td []
            [ a [ href (bankDetailsPath bank.slug) ] [ text bank.name ]
            ]
       ]
