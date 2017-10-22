module Ad.Model exposing (..)

import Land.Model exposing (..)


type alias Ad =
    { active : Bool
    , land : Land
    , house_price : Int
    , land : Maybe Land
    }
