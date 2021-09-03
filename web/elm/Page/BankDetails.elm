module Page.BankDetails exposing (..)

import Html exposing (Html)
import Msgs exposing (Msg)
import Model exposing (Model)
import Bank.Details

view : Model -> String -> Html Msg
view model bankSlug =
    Bank.Details.view model bankSlug