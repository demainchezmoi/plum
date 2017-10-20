module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Project.View exposing (projectPageView, projectStepPageView)
import Routing exposing (Route(..))
import ViewHelpers exposing (notFoundView, loader)


view : Model -> Html Msg
view model =
    let
        loadingOverlay =
            case model.loading of
                True ->
                    [ loader ]

                False ->
                    []
    in
        section []
            [ div [] (loadingOverlay ++ [ page model ]) ]


page : Model -> Html Msg
page model =
    case model.route of
        NotFoundRoute ->
            notFoundView

        ProjectRoute projectId ->
            projectPageView model

        ProjectStepRoute projectId projectStep ->
            projectStepPageView projectStep model
