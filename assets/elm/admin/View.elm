module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)
import LandList.View exposing (landListView)
import Routing exposing (Route(..))


view : Model -> Html Msg
view model =
    section [] [ div [] [ page model ] ]


page : Model -> Html Msg
page model =
    case model.route of
        LandListRoute ->
            landListView model

        NotFoundRoute ->
            notFoundView


notFoundView : Html Msg
notFoundView =
    text "Route not found"
