module Land.Model exposing (..)

import Ad.Form exposing (..)
import Land.Form exposing (..)
import Location.Model exposing (..)


type alias LandId =
    Int


type alias Land =
    { city : String
    , department : String
    , location : Maybe Location
    , price : Int
    , surface : Int
    , description : String
    , images : List String
    , id : LandId
    }


type alias LandList =
    List Land
