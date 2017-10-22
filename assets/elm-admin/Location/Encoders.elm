module Location.Encoders exposing (..)

import Json.Encode as Encode exposing (..)
import Location.Model exposing (..)


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
