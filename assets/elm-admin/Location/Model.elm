module Location.Model exposing (..)

import Form.Validate as Validate exposing (..)


type alias Location =
    { lat : Float
    , lng : Float
    }


locationValidation : Validation () Location
locationValidation =
    succeed Location
        |> andMap (field "lat" float)
        |> andMap (field "lng" float)
