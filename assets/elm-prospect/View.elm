module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Routing exposing (Route(..))
import Project.Model exposing (ProjectId)
import Project.View exposing (projectView)


view : Model -> Html Msg
view model =
    section [] [ div [] [ page model ] ]


page : Model -> Html Msg
page model =
    case model.route of
        NotFoundRoute ->
            notFoundView

        ProjectRoute projectId ->
            projectView projectId


notFoundView : Html Msg
notFoundView =
    text "Adresse introuvable"
