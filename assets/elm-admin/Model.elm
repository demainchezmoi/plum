module Model exposing (..)

import Routing exposing (Route)
import RemoteData exposing (..)
import LandList.Model exposing (LandList)


type alias ApiToken =
    String


type alias Method =
    String


type alias Url =
    String


type alias Flags =
    { apiToken : ApiToken
    }


type alias Model =
    { landList : WebData LandList
    , error : Maybe String
    , apiToken : ApiToken
    , route : Route
    }


initialModel : ApiToken -> Route -> Model
initialModel apiToken route =
    { landList = Loading
    , error = Nothing
    , apiToken = apiToken
    , route = route
    }
