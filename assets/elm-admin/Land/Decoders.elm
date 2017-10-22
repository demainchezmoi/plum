module Land.Decoders exposing (..)

import Ad.Model exposing (..)
import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))
import Land.Model exposing (..)
import Location.Model exposing (..)


idDecoder : JD.Decoder Int
idDecoder =
    at [ "id" ] <| int


location : JD.Decoder Location
location =
    succeed
        Location
        |: (field "lat" float)
        |: (field "lng" float)


landDecoder : JD.Decoder Land
landDecoder =
    succeed
        Land
        |: (field "city" string)
        |: (field "department" string)
        |: (field "location" (maybe location))
        |: (field "price" int)
        |: (field "surface" int)
        |: (field "description" string)
        |: (field "images" (list string))
        |: (field "id" int)
        |: oneOf [ field "ads" (list idDecoder), succeed [] ]
