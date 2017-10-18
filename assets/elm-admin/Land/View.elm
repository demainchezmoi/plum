module Land.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Land.Model exposing (Land)
import Messages exposing (..)
import Model exposing (..)
import String exposing (join, concat)
import RemoteData exposing (..)
import ViewHelpers exposing (..)


landItemView : Land -> Html Msg
landItemView land =
    let
        infos =
            join " - "
                [ concat [ toString land.price, " euros" ]
                , concat [ toString land.surface, " m2" ]
                ]

        title =
            String.join "" [ "Terrain à ", land.city, " (", land.department, ")" ]
    in
        div [ class "card mb-2" ]
            [ div [ class "card-body" ]
                [ div [ class "card-title" ] [ text title ]
                , div [ class "card-text" ] [ text infos ]
                ]
            ]


landNewView : Model -> Html Msg
landNewView model =
    div [] [ text "land new" ]


landShowView : Model -> Html Msg
landShowView model =
    case model.land of
        Failure err ->
            failureView err

        NotAsked ->
            notAskedView

        Loading ->
            loadingView

        Success land ->
            landShowSuccessView model land


landShowSuccessView : Model -> Land -> Html Msg
landShowSuccessView model land =
    landItemView land
