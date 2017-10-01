module Project.View exposing (..)

import Html exposing (..)
import Project.Model exposing (ProjectId)
import Messages exposing (..)
import Model exposing (..)
import Project.Model exposing (..)


projectView : Project -> Html Msg
projectView project =
    project |> toString |> text
