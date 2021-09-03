module Bank.Model exposing (..)

import RemoteData exposing (WebData)


type alias BankModel =
    { banks: WebData(List Bank)
    }


type alias Bank =
    { name: String
    , slug: String
    , currency: WebData Currency
    }


type alias Currency =
    { buy: Float
    , sell: Float
    }


initialBankModel : BankModel
initialBankModel =
    { banks = RemoteData.Loading
    }