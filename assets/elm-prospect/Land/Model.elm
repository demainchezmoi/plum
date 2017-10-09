module Land.Model exposing (..)


type alias Coordinates =
    { lat : Float
    , lng : Float
    }


type alias Land =
    { city : String
    , department : String
    , lat : Float
    , lng : Float
    , price : Int
    , surface : Int
    , description : String
    , images : List String
    }


coordinatesFromLand : Land -> Coordinates
coordinatesFromLand land =
    Coordinates land.lat land.lng
