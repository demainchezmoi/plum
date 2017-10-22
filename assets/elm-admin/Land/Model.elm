module Land.Model exposing (..)

import Ad.Form exposing (..)
import Dict exposing (Dict)
import Land.Form exposing (..)
import Location.Model exposing (..)
import RemoteData exposing (..)


type alias Lands =
    Dict Int (WebData Land)


type alias Land =
    { city : String
    , department : String
    , location : Maybe Location
    , price : Int
    , surface : Int
    , description : String
    , images : List String
    , id : Int
    , ads : List Int
    }
