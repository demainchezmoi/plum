module Model exposing (..)

import Routing exposing (Route)
import RemoteData exposing (..)
import Project.Model exposing (Project, ProjectId)


type alias ApiToken =
    String


type alias Method =
    String


type alias Url =
    String


type alias Flags =
    { apiToken : ApiToken
    }


type SlideAnimation
    = EnterRight
    | EnterLeft
    | None


type alias Model =
    { project : WebData Project
    , houseColor : String
    , error : Maybe String
    , apiToken : ApiToken
    , route : Route
    }


initialModel : ApiToken -> Route -> Model
initialModel apiToken route =
    { project = Loading
    , houseColor = "Maison-leo-configurateur-1.png"
    , error = Nothing
    , apiToken = apiToken
    , route = route
    }
