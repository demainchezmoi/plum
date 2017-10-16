module LandList.Decoders exposing (..)

import Json.Decode as JD exposing (..)
import Land.Decoders exposing (landDecoder)
import LandList.Model exposing (LandList)


landListDecoder : JD.Decoder LandList
landListDecoder =
    at [ "data" ] <|
        JD.list landDecoder
