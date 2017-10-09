module Model exposing (..)

import Maps
import Messages exposing (Msg)
import Project.Model exposing (Project, ProjectId)
import RemoteData exposing (..)
import Routing exposing (Route)
import Window


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
    , windowSize : Window.Size
    , landMap : Maps.Model Msg
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
    , windowSize = Window.Size 500 500
    , landMap = Maps.defaultModel
    , error = Nothing
    , apiToken = apiToken
    , route = route
    , houseColor1 = Nothing
    , houseColor2 = Nothing
    , contribution = Nothing
    , netIncome = Nothing
    , phoneNumber = Nothing
    }
