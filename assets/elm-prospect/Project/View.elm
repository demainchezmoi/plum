module Project.View exposing (..)

import Html exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Project.Model exposing (..)
import ViewHelpers exposing (remoteDataView)


projectPageView : Model -> Html Msg
projectPageView model =
    remoteDataView model.project projectView


projectView : Project -> Html Msg
projectView project =
    ("Projet : " ++ toString project.id)
        |> text
