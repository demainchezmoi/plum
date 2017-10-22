module Ad.Model exposing (..)

import Dict exposing (Dict)
import Land.Model exposing (..)
import RemoteData exposing (..)


type alias Ads =
    Dict Int (WebData Ad)


type alias Ad =
    { active : Bool
    , house_price : Int
    , land_id : Int
    , id : Int
    }
