module Auth.Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, id, name, type_, for, value)
import Html.Events exposing (onInput, onSubmit)
import Msgs exposing (Msg(OnLoginChange))
import Model exposing (Model)
import Auth.Model exposing (LoginModel, LoginFormField(..))
import Auth.Msgs exposing (LoginMsg(..))


view : Model -> Html Msg
view model =
    div []
        [ h4 [ class "center-align" ]
             [ text "Please login" ]
        , div [ class "center-align" ]
              [ loginForm model.loginData ]
        ]


loginForm : LoginModel -> Html Msg
loginForm loginData =
    form [ onSubmit (OnLoginChange OnLoginFormSubmit) ]
         [ loginError loginData.error
         , div [ class "row" ]
               [ div [ class "input-field col s12 l6 offset-l3" ]
                     [ input [ id "username"
                             ,  name "username"
                             , type_ "text"
                             , value loginData.username
                             , onInput (\value -> OnLoginChange (OnLoginFormChange UsernameField value))
                             ]
                             []
                     , label [ for "username" ] [ text "Username" ]
                     ]
               ]
         , div [ class "row" ]
               [ div [ class "input-field col s12 l6 offset-l3" ]
                     [ input [ id "password"
                             ,  name "password"
                             , type_ "password"
                             , value loginData.password
                             , onInput (\value -> OnLoginChange (OnLoginFormChange PasswordField value))
                             ]
                             []
                     , label [ for "password" ] [ text "Password" ]
                     ]
               ]
         , div [ class "row" ]
               [ div [ class "align-center col s12" ]
                     [ button
                         [ class "waves-effect waves-light btn"
                         , type_ "submit"
                         ]
                         [ text "Login" ]
                     ]
               ]
         , div [ ] [ text "Hint: login: demo / password: 123123" ]
         ]


loginError : Bool -> Html Msg
loginError error =
    case error of
        True ->
            div [ class "align-center" ]
                [ text "Wrong login or password" ]
        False ->
            div []
                []
