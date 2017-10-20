module Land.Decoders exposing (..)

import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))
import Land.Model exposing (Land, Location)


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
