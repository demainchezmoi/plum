module Model exposing (..)

import Routing exposing (Route)
import RemoteData exposing (..)
import Project.Model exposing (Project)


type alias ApiToken =
    String


type alias Model =
    { project : WebData Project
    , error : Maybe String
    , apiToken : ApiToken
    , route : Route
    }


type alias Flags =
    { apiToken : ApiToken
    }


initialModel : ApiToken -> Route -> Model
initialModel apiToken route =
    { project = Loading
    , error = Nothing
    , apiToken = apiToken
    , route = route
    }
