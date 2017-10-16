module Dashboard.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)


dashboardView : Model -> Html Msg
dashboardView model =
    div [] [ text "dashboardView" ]
