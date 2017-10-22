module Model exposing (..)

import Form exposing (Form)
import Form.Field as Field
import Form.Validate as Validate exposing (..)
import Land.Form exposing (..)
import Land.Model exposing (..)
import RemoteData exposing (..)
import Routing exposing (Route)
import Ad.Form exposing (..)


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
    , landForm =
        Form.initial
            [ ( "images", Field.list [ Field.string "" ] )
            , ( "ads", Field.list [ initialAdItemField ] )
            ]
            landFormValidation
    , error = Nothing
    , apiToken = apiToken
    , route = route
    }
