module Land.Form exposing (..)

import Ad.Form exposing (..)
import Form exposing (Form)
import Form.Field as Field exposing (Field)
import Form.Validate as Validate exposing (..)
import List as L
import Location.Form exposing (..)
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


landFormToGroup : LandForm -> List ( String, Field )
landFormToGroup landForm =
    [ ( "city", Field.string landForm.city )
    , ( "department", Field.string landForm.department )
    , ( "location", locationField landForm.location )
    , ( "price", Field.string <| toString <| landForm.price )
    , ( "surface", Field.string <| toString <| landForm.surface )
    , ( "description", Field.string landForm.description )
    , ( "images", Field.list (landForm.images |> L.map Field.string) )
    ]
