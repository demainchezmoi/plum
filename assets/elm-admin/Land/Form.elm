module Land.Form exposing (..)

import Ad.Form exposing (..)
import Form.Validate as Validate exposing (..)
import Location.Model exposing (..)


type alias LandForm =
    { city : String
    , department : String
    , location : Maybe Location
    , price : Int
    , surface : Int
    , description : String
    , images : List String
    , ads : List AdForm
    }


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
        |> andMap (field "ads" (list adFormValidation))
