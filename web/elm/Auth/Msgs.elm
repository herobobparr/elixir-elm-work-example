module Auth.Msgs exposing (..)

import Http
import Auth.Model exposing (LoginFormField, AuthModel)

type LoginMsg
    = OnLoginFormChange LoginFormField String
    | OnLoginFormSubmit
    | OnLoginSucceeded (Result Http.Error AuthModel)
