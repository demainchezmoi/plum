module Ad.Encoders exposing (..)

import Json.Encode as Encode exposing (..)
import Ad.Form exposing (..)


adFormEncoder : AdForm -> Value
adFormEncoder adForm =
    Encode.object
        [ ( "active", bool adForm.active )
        , ( "house_price", int adForm.house_price )
        ]
