module Bank.Commands exposing (..)

import Http exposing (header)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, hardcoded)
import Bank.Model exposing (BankModel, Bank, Currency)
import Bank.Msgs exposing (BankMsg(..))
import Msgs exposing (Msg(OnBankChange))
import Model exposing (Model)
import RemoteData


bankListUrl : String
bankListUrl =
    "/api/currency"


currencyUrl : String -> String
currencyUrl bankSlug =
    "/api/currency/" ++ bankSlug


loadBankList : String -> Http.Request (List Bank)
loadBankList token =
    let
        tokenString = "Bearer " ++ token
    in
        Http.request
            { method = "GET"
            , expect = Http.expectJson bankListDecoder
            , headers = [ header "Authorization" tokenString ]
            , url = bankListUrl
            , body = Http.emptyBody
            , timeout = Nothing
            , withCredentials = False
            }


loadingBankListCmd : Model -> Cmd Msg
loadingBankListCmd model =
    case model.auth of
        Just auth ->
            loadBankList auth.token
                |> RemoteData.sendRequest
                |>  Cmd.map (\value -> (OnBankChange (OnLoadBankList value)))
        Nothing ->
            Cmd.none


loadCurrency : String -> String -> Http.Request Currency
loadCurrency token slug =
    let
        tokenString = "Bearer " ++ token
    in
        Http.request
            { method = "GET"
            , expect = Http.expectJson currencyDecoder
            , headers = [ header "Authorization" tokenString ]
            , url = currencyUrl slug
            , body = Http.emptyBody
            , timeout = Nothing
            , withCredentials = False
            }


loadCurrencyCmd : Model -> String -> Cmd Msg
loadCurrencyCmd model slug =
    case model.auth of
        Just auth ->
            loadCurrency auth.token slug
                |> RemoteData.sendRequest
                |> Cmd.map (\value -> (OnBankChange (OnLoadCurrency (slug, value))))
        Nothing ->
            Cmd.none


bankListDecoder : Decode.Decoder (List Bank)
bankListDecoder =
    Decode.list bankDecoder


bankDecoder : Decode.Decoder Bank
bankDecoder =
    decode Bank
        |> required "name" Decode.string
        |> required "slug" Decode.string
        |> hardcoded RemoteData.NotAsked


currencyDecoder : Decode.Decoder Currency
currencyDecoder =
    decode Currency
        |> required "buy" Decode.float
        |> required "sell" Decode.float
