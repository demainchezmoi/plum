module LandList.View exposing (indexView)

import Land.View exposing (landView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)


indexView : Model -> Html Msg
indexView model =
    div
        [ id "home_index" ]
        [ div
            []
            [ landsList model ]
        ]


landsList : Model -> Html Msg
landsList model =
    if (List.length (model.landList.entries) > 0) then
        model.landList.entries
            |> List.map landView
            |> div [ class "cards-wrapper" ]
    else
        let
            classes =
                classList
                    [ ( "warning", True ) ]
        in
            div
                [ classes ]
                [ span
                    [ class "fa-stack" ]
                    [ i [ class "fa fa-meh-o fa-stack-2x" ] [] ]
                , h4
                    []
                    [ text "No lands found..." ]
                ]
