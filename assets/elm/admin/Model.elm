module Model exposing (..)

import Routing exposing (Route)
import RemoteData exposing (..)
import LandList.Model exposing (LandList)


type alias ApiToken =
    String


type alias Model =
    { landList : WebData LandList
    , error : Maybe String
    , apiToken : ApiToken
    , route : Route
    }


type alias Flags =
    { apiToken : ApiToken
    }


initialModel : ApiToken -> Route -> Model
initialModel apiToken route =
    { landList = Loading
    , error = Nothing
    , apiToken = apiToken
    , route = route
    }
