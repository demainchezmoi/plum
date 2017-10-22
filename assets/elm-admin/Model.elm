module Model exposing (..)

import Ad.Form exposing (..)
import Ad.Model exposing (..)
import Dict exposing (Dict)
import Form exposing (Form)
import Form.Field as Field
import Form.Validate as Validate exposing (..)
import Land.Form exposing (..)
import Land.Model exposing (..)
import List as L
import RemoteData exposing (..)
import Routing exposing (Route)


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
    { lands : Lands
    , ads : Ads
    , landForm : Form () LandForm
    , apiToken : ApiToken
    , route : Route
    }


initialModel : ApiToken -> Route -> Model
initialModel apiToken route =
    { lands = Dict.empty
    , ads = Dict.empty
    , landForm =
        Form.initial
            [ ( "images", Field.list [ Field.string "" ] )
            , ( "ads", Field.list [ initialAdItemField ] )
            ]
            landFormValidation
    , apiToken = apiToken
    , route = route
    }
