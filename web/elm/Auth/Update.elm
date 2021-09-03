module Auth.Update exposing (..)

import Model exposing (Model)
import Msgs exposing (Msg)
import Navigation exposing (newUrl)
import Auth.Msgs exposing (LoginMsg(..))
import Auth.Model exposing (LoginModel, LoginFormField(..))
import Auth.Commands exposing (sendLoginDataCmd)
import Routing exposing (mainPath)
import RemoteData

loginUpdate : LoginMsg -> Model -> (Model, Cmd Msg)
loginUpdate message model =
    case message of
        OnLoginFormChange field value ->
            let
                loginData = updateLoginData model.loginData field value
            in
                ( { model | loginData = loginData }, Cmd.none )
        OnLoginFormSubmit ->
            ( model, sendLoginDataCmd model.loginData )
        OnLoginSucceeded (Ok auth) ->
            ({ model | auth = Just auth }, newUrl mainPath)
        OnLoginSucceeded (Err error) ->
            let
                loginData = setLoginError model.loginData
            in
                ( { model | loginData = loginData }, Cmd.none )


updateLoginData : LoginModel -> LoginFormField -> String -> LoginModel
updateLoginData loginData field value =
    case field of
        UsernameField ->
            { loginData | username = value }
        PasswordField ->
            { loginData | password = value }


setLoginError : LoginModel -> LoginModel
setLoginError loginData =
    { loginData | error = True }
