module Bank.Update exposing (..)

import Msgs exposing (Msg)
import Model exposing (Model)
import Bank.Msgs exposing (BankMsg(..))
import Bank.Model exposing (BankModel, Currency, Bank)
import RemoteData exposing (WebData)


bankUpdate: BankMsg -> Model -> (Model, Cmd Msg)
bankUpdate message model =
    case message of
        OnLoadBankList response ->
            let
                bankModel = model.bank
                updatedBankModel = { bankModel | banks = response }
            in
                ({ model | bank = updatedBankModel }, Cmd.none)
        OnLoadCurrency (slug, response) ->
            let
                bankModel = setCurrency model.bank slug response
            in
            ({ model | bank = bankModel }, Cmd.none)


setCurrency : BankModel -> String -> WebData Currency -> BankModel
setCurrency bankModel slug response =
    let
        updateFunc = updateBankCurrencyBySlug slug response
        mapFunc banks = List.map updateFunc banks
        banks = RemoteData.map mapFunc bankModel.banks
    in
        { bankModel | banks = banks }


updateBankCurrencyBySlug : String -> WebData Currency -> Bank -> Bank
updateBankCurrencyBySlug slug response bank =
    if
        bank.slug == slug
    then
        { bank | currency = response }
    else
        bank

