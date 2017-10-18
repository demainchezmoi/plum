module Land.Decoders exposing (..)

import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))
import Land.Model exposing (Land)


landShowDecoder : JD.Decoder Land
landShowDecoder =
    at [ "data" ] <| landDecoder


landDecoder : JD.Decoder Land
landDecoder =
    succeed
        Land
        |: (field "city" string)
        |: (field "department" string)
        |: (field "lat" float)
        |: (field "lng" float)
        |: (field "price" int)
        |: (field "surface" int)
        |: (field "description" string)
        |: (field "images" (list string))
        |: (field "id" int)
