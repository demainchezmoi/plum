module Ad.Model exposing (..)

import Dict exposing (Dict)
import Land.Model exposing (..)
import RemoteData exposing (..)


type alias Ads =
    Dict Int (WebData Ad)


type alias Ad =
    { active : Bool
    , land : Land
    , house_price : Int

    -- , land : Maybe Int
    }
