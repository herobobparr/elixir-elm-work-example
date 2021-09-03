module Bank.Details exposing (..)

import Html exposing (..)
import Msgs exposing (Msg)
import Model exposing (Model)
import Bank.Model exposing (BankModel, Bank, Currency)
import RemoteData exposing (WebData)


view : Model -> String -> Html Msg
view model bankSlug =
    let
       bank = findBank model.bank bankSlug
    in
       displayBank bank


findBank : BankModel -> String -> Maybe Bank
findBank bankModel bankSlug =
    case bankModel.banks of
        RemoteData.NotAsked ->
            Nothing
        RemoteData.Loading ->
            Nothing
        RemoteData.Success banks ->
            banks
                |> List.filter (\item -> item.slug == bankSlug)
                |> List.head
        RemoteData.Failure error ->
            Nothing


displayBank : Maybe Bank -> Html Msg
displayBank bank =
    case bank of
        Just bank ->
            div []
                [ h4 [] [ text bank.name ]
                , maybeDisplayCurrency bank.currency
                ]
        Nothing ->
            div []
                [ text "bank not found" ]


maybeDisplayCurrency : WebData Currency -> Html Msg
maybeDisplayCurrency currency =
    case currency of
        RemoteData.NotAsked ->
            text "Loading..."
        RemoteData.Loading ->
            text "Loading..."
        RemoteData.Success currency ->
            displayCurrency currency
        RemoteData.Failure err ->
            text "Someting goes wrong"


displayCurrency : Currency -> Html Msg
displayCurrency currency =
    table []
          [ tr []
               [ th [] [ text "Buy" ]
               , td [] [ text ((toString currency.buy) ++ " RUR") ]
               ]
          , tr []
               [ th [] [ text "Sell" ]
               , td [] [ text ((toString currency.sell) ++ " RUR") ]
               ]
          ]
