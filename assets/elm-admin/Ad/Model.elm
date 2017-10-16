module Ad.Model exposing (..)

import Land.Model exposing (Land)


type alias Ad =
    { active : Bool
    , land : Land
    }
