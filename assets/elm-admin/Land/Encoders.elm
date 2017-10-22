module Land.Encoders exposing (..)

import Json.Encode as Encode exposing (..)
import Land.Model exposing (..)
import Land.Form exposing (LandForm)
import Location.Encoders exposing (..)
import Location.Model exposing (..)
import Ad.Encoders exposing (..)


landFormEncoder : LandForm -> Value
landFormEncoder landForm =
    Encode.object
        [ ( "city", string landForm.city )
        , ( "department", string landForm.department )
        , ( "location", locationEncoder landForm.location )
        , ( "price", int landForm.price )
        , ( "surface", int landForm.surface )
        , ( "description", string landForm.description )
        , ( "images", list (List.map string landForm.images) )
        , ( "ads", list (List.map adFormEncoder landForm.ads) )
        ]
