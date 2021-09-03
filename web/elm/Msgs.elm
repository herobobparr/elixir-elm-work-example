module Msgs exposing (..)

import Navigation exposing (Location)
import Auth.Msgs exposing (LoginMsg)
import Bank.Msgs exposing (BankMsg)

type Msg
    = NoOp
    | OnLocationChange  Location
    | OnLoginChange LoginMsg
    | OnBankChange BankMsg
