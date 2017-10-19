module Model exposing (..)

import Routing exposing (Route)
import RemoteData exposing (..)
import Land.Model exposing (Land, LandForm, validation)
import LandList.Model exposing (LandList)
import Form exposing (Form)
import Form.Validate as Validate exposing (..)


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
    , landForm : Form () LandForm
    , error : Maybe String
    , apiToken : ApiToken
    , route : Route
    }


initialModel : ApiToken -> Route -> Model
initialModel apiToken route =
    { landList = NotAsked
    , land = NotAsked
    , landForm = Form.initial [] validation
    , error = Nothing
    , apiToken = apiToken
    , route = route
    }
