module Ad.Decoders exposing (..)

import Ad.Model exposing (Ad)
import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))


adDecoder : JD.Decoder Ad
adDecoder =
    succeed
        Ad
        |: (field "active" bool)
        |: (field "house_price" int)
        |: (field "land_id" int)
        |: (field "id" int)
        |: (field "link" string)
