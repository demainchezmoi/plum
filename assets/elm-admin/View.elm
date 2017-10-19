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


genericNav : Html Msg
genericNav =
    h5 [ class "ml-header row justify-content-between" ]
        [ div [ class "col" ] [ text " Maisons Léo - Admin" ] ]


inLayout : Html Msg -> Html Msg
inLayout view =
    div [ class "container mb-2" ]
        [ div [ class "row" ]
            [ div [ class "col" ]
                [ div [ class "mb-2" ] [ genericNav ]
                , view
                ]
            ]
        ]


page : Model -> Html Msg
page model =
    let
        view =
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
    in
        view |> inLayout


notFoundView : Html Msg
notFoundView =
    text "Route not found"
