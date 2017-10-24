module DecodedTypes exposing (..)

import Ad.Model exposing (..)
import Ad.Decoders exposing (..)
import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))
import Land.Model exposing (..)
import Land.Decoders exposing (..)


type alias DecodedLand =
    { land : Land
    , ads : List Ad
    }


landResponseDecoder : JD.Decoder DecodedLand
landResponseDecoder =
    succeed
        DecodedLand
        |: landDecoder
        |: oneOf
            [ at [ "ads" ] <| list adDecoder
            , succeed []
            ]


landShowResponseDecoder : JD.Decoder DecodedLand
landShowResponseDecoder =
    at [ "data" ] <| landResponseDecoder


landListResponseDecoder : JD.Decoder (List DecodedLand)
landListResponseDecoder =
    at [ "data" ] <| JD.list landResponseDecoder
