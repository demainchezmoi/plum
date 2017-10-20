module Land.Model exposing (..)


type alias Location =
    { lat : Float
    , lng : Float
    }


type alias Land =
    { city : String
    , department : String
    , location : Maybe Location
    , price : Int
    , surface : Int
    , description : String
    , images : List String
    }
