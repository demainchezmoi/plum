module LandList.View exposing (landListView)

import Land.View exposing (landView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import LandList.Model exposing (LandList)
import Model exposing (..)
import RemoteData exposing (..)


landListView : Model -> Html Msg
landListView model =
    case model.landList of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success landList ->
            renderLandList landList


renderLandList : LandList -> Html Msg
renderLandList landList =
    landList
        |> List.map landView
        |> div [ class "cards-wrapper" ]
