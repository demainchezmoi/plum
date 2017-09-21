module LandList.View exposing (indexView)

import Land.View exposing (landView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)
import RemoteData exposing (..)


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
    case model.landList of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success landList ->
            viewLandList landList


viewLandList : LandList -> Html Msg
viewLandList landList =
    landList
        |> List.map landView
        |> div [ class "cards-wrapper" ]
