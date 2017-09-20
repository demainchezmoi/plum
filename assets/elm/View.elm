module View exposing (..)

import LandList.View exposing (indexView)
import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)


view : Model -> Html Msg
view model =
    section
        []
        [ headerView
        , div []
            [ indexView model ]
        ]


headerView : Html Msg
headerView =
    header
        [ class "main-header" ]
        [ h1
            []
            [ text "Admin app" ]
        ]
