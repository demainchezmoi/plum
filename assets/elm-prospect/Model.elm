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
    , error : Maybe String
    , apiToken : ApiToken
    , route : Route
    , houseColor1 : Maybe String
    , houseColor2 : Maybe String
    , contribution : Maybe Int
    , netIncome : Maybe Int
    , phoneNumber : Maybe String
    }


initialModel : ApiToken -> Route -> Model
initialModel apiToken route =
    { project = Loading
    , error = Nothing
    , apiToken = apiToken
    , route = route
    , houseColor1 = Nothing
    , houseColor2 = Nothing
    , contribution = Nothing
    , netIncome = Nothing
    , phoneNumber = Nothing
    }
