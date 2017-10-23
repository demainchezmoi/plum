module Location.Form exposing (..)

import Form.Field as Field exposing (Field)
import Location.Model exposing (..)


locationField : Maybe Location -> Field
locationField maybeLocation =
    case maybeLocation of
        Just location ->
            Field.group
                [ ( "lat", Field.string <| toString <| location.lat )
                , ( "lng", Field.string <| toString <| location.lng )
                ]

        Nothing ->
            Field.value Field.EmptyField
