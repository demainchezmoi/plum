module Land.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)


landView : Land -> Html Msg
landView land =
    div [] [ text land.city ]
