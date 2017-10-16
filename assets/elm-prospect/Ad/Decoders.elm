module Ad.Decoders exposing (..)

import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))
import Land.Decoders exposing (landDecoder)
import Ad.Model exposing (Ad)


adDecoder : JD.Decoder Ad
adDecoder =
    succeed
        Ad
        |: (field "active" bool)
        |: (field "land" landDecoder)
        |: (field "house_price" int)
        |: (field "land_adaptation_price" int)
