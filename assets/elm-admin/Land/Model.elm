module Land.Model exposing (..)


type alias LandId =
    Int


type alias Land =
    { city : String
    , department : String
    , lat : Float
    , lng : Float
    , price : Int
    , surface : Int
    , description : String
    , images : List String
    , id : LandId
    }
