module Project.View exposing (..)

import Html exposing (..)
import Project.Model exposing (ProjectId)
import Messages exposing (..)


projectView : ProjectId -> Html Msg
projectView projectId =
    projectId |> text
