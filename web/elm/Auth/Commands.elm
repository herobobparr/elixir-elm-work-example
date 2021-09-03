module Auth.Commands exposing (..)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)
import Auth.Model exposing (LoginModel, AuthModel)
import Auth.Msgs exposing (LoginMsg(OnLoginSucceeded))
import Msgs exposing (Msg(OnLoginChange))


loginUrl : String
loginUrl =
    "/api/auth/login"


sendLoginData : LoginModel -> Http.Request AuthModel
sendLoginData loginData =
    Http.request
        { body = encodeLoginData loginData |> Http.jsonBody
        , expect = Http.expectJson authDecoder
        , headers = []
        , method = "POST"
        , timeout = Nothing
        , url = loginUrl
        , withCredentials = False
        }


sendLoginDataCmd : LoginModel -> Cmd Msg
sendLoginDataCmd loginData =
    sendLoginData loginData
        |> Http.send (\value -> OnLoginChange (OnLoginSucceeded value))


authDecoder : Decode.Decoder AuthModel
authDecoder =
    decode AuthModel
        |> required "token" Decode.string


encodeLoginData : LoginModel -> Encode.Value
encodeLoginData loginData =
    let
        attributes =
            [ ("username", Encode.string loginData.username)
            , ("password", Encode.string loginData.password)
            ]
    in
        Encode.object attributes

