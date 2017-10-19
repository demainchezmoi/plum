module Ad.Model exposing (..)

import Land.Model exposing (Land)


type alias Ad =
    { active : Bool
    , land : Land
    , house_price : Int
    }


totalPrice : Ad -> Int
totalPrice ad =
    ad.land.price + ad.house_price
