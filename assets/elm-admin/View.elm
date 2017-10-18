module View exposing (..)

import Dashboard.View exposing (dashboardView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Land.View exposing (landNewView, landShowView)
import LandList.View exposing (landListView)
import Messages exposing (..)
import Model exposing (..)
import Routing exposing (Route(..))


view : Model -> Html Msg
view model =
    section [] [ div [] [ page model ] ]


page : Model -> Html Msg
page model =
    case model.route of
        DashboardRoute ->
            dashboardView model

        LandListRoute ->
            landListView model

        LandNewRoute ->
            landNewView model

        LandShowRoute landId ->
            landShowView model

        NotFoundRoute ->
            notFoundView


notFoundView : Html Msg
notFoundView =
    text "Route not found"
