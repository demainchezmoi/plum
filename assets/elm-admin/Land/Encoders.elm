module Land.Encoders exposing (..)

import Json.Encode as Encode exposing (..)
import Land.Model exposing (..)


locationEncoder : Maybe Location -> Value
locationEncoder maybeLocation =
    case maybeLocation of
        Nothing ->
            null

        Just location ->
            Encode.object
                [ ( "lat", float location.lat )
                , ( "lng", float location.lng )
                ]


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
        ]
