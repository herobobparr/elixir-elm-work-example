module Routing exposing (..)

import Navigation exposing (Location)
import Model exposing (Model, Route(..))
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
         [ map MainRoute top
         , map LoginRoute (s "login")
         , map LogoutRoute (s "logout")
         , map AboutRoute (s "about")
         , map BankDetailsRoute (s "bank" </> string)
         ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route
        Nothing ->
            NotFoundRoute


mainPath : String
mainPath = "#"


loginPath : String
loginPath = "#login"


logoutPath : String
logoutPath = "#logout"


aboutPath : String
aboutPath = "#about"

bankDetailsPath : String -> String
bankDetailsPath bankSlug =
    "#bank/" ++ bankSlug
