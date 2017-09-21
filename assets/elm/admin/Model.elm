module Model exposing (..)

import Routing exposing (Route)
import RemoteData exposing (..)


type alias ApiToken =
    String


type alias Model =
    { landList : WebData LandList
    , error : Maybe String
    , apiToken : ApiToken
    , route : Route
    }


type alias Land =
    { city : String
    , department : String
    , lat : Float
    , lng : Float
    , price : Int
    , surface : Int
    }


type alias LandList =
    List Land


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
