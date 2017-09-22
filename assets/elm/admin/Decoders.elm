module Decoders exposing (..)

import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))
import Model exposing (..)
import LandList.Model exposing (LandList)
import Land.Model exposing (Land)


landListDecoder : JD.Decoder LandList
landListDecoder =
    JD.list landDecoder


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
