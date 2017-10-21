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
    , department : String
    , location : Maybe Location
    , price : Int
    , surface : Int
    , description : String
    , images : List String
    }


locationValidation : Validation () Location
locationValidation =
    succeed Location
        |> andMap (field "lat" float)
        |> andMap (field "lng" float)


landFormValidation : Validation () LandForm
landFormValidation =
    succeed LandForm
        |> andMap (field "city" string)
        |> andMap (field "department" string)
        |> andMap (field "location" (maybe locationValidation))
        |> andMap (field "price" int)
        |> andMap (field "surface" int)
        |> andMap (field "description" string)
        |> andMap (field "images" (list string))
