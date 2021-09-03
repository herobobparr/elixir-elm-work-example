module Bank.Msgs exposing (..)
import RemoteData exposing (WebData)

import Bank.Model exposing (Bank, Currency)

type BankMsg
    = OnLoadBankList (WebData (List Bank))
    | OnLoadCurrency (String, (WebData Currency))
