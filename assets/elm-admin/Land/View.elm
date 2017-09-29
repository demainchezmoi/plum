module Land.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Land.Model exposing (Land)
import String exposing (join, concat)


landItemView : Land -> Html Msg
landItemView land =
    let
        infos =
            join " - "
                [ concat [ "lat: ", toString land.lat ]
                , concat [ "lng: ", toString land.lng ]
                , concat [ land.city, " (", land.department, ")" ]
                , concat [ toString land.price, " euros" ]
                , concat [ toString land.surface, " m2" ]
                ]
    in
        div [ class "card mb-2" ] [ div [ class "card-body" ] [ text infos ] ]