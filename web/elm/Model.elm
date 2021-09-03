module Model exposing (..)
import Auth.Model exposing (LoginModel, initialLoginModel, AuthModel, initialAuthModel)
import Bank.Model exposing (BankModel, initialBankModel)


type alias Model =
    { value: String
    , route: Route
    , loginData: LoginModel
    , auth: Maybe AuthModel
    , bank: BankModel
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , value = "Hello Phoenix"
    , loginData = initialLoginModel
    , auth = initialAuthModel
    , bank = initialBankModel
    }


type Route
    = MainRoute
    | BankDetailsRoute String
    | LoginRoute
    | LogoutRoute
    | AboutRoute
    | NotFoundRoute
