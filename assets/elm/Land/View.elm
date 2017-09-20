module Land.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)
import String exposing (join, concat)


landView : Land -> Html Msg
landView land =
    let
        infos =
            join " - "
                [ concat [ "lat: ", toString land.lat ]
                , concat [ "lng: ", toString land.lng ]
                , land.city
                , concat [ "(", land.department, ")" ]
                , concat [ toString land.price, " euros" ]
                , concat [ toString land.surface, " m2" ]
                ]
    in
        div [ class "card mb-2" ] [ div [ class "card-body" ] [ text infos ] ]
