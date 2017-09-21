module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)
import LandList.View exposing (indexView)
import Routing exposing (Route(..))


view : Model -> Html Msg
view model =
    section
        []
        [ headerView
        , div []
            [ page model ]
        ]


headerView : Html Msg
headerView =
    header
        [ class "main-header" ]
        [ h1
            []
            [ text "Admin app" ]
        ]


page : Model -> Html Msg
page model =
    case model.route of
        LandsRoute ->
            indexView model

        NotFoundRoute ->
            notFoundView


notFoundView : Html Msg
notFoundView =
    text "Route not found"
