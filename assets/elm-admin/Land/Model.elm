module Land.Model exposing (..)

import Form.Validate as Validate exposing (..)


type alias LandId =
    Int


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
    , id : LandId
    }


type alias LandForm =
    { city : String
    }


validation : Validation () LandForm
validation =
    map LandForm
        (field "city" string)
