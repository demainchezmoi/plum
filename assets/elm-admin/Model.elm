module Model exposing (..)

import Routing exposing (Route)
import RemoteData exposing (..)
import Land.Model exposing (Land)
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
    , land : WebData Land
    , error : Maybe String
    , apiToken : ApiToken
    , route : Route
    }


initialModel : ApiToken -> Route -> Model
initialModel apiToken route =
    { landList = NotAsked
    , land = NotAsked
    , error = Nothing
    , apiToken = apiToken
    , route = route
    }
