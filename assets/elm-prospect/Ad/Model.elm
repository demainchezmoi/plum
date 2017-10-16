module Ad.Model exposing (..)

import Land.Model exposing (Land)


type alias Ad =
    { active : Bool
    , land : Land
    , house_price : Int
    , land_adaptation_price : Int
    }


totalPrice : Ad -> Int
totalPrice ad =
    ad.land.price + ad.house_price + ad.land_adaptation_price
