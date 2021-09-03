module Auth.Model exposing (..)

type alias LoginModel =
    { username: String
    , password: String
    , error: Bool
    }


initialLoginModel : LoginModel
initialLoginModel =
    { username = ""
    , password = ""
    , error = False
    }


type LoginFormField
    = UsernameField
    | PasswordField


type alias AuthModel =
    { token : String }

initialAuthModel: Maybe AuthModel
initialAuthModel =
    Nothing
