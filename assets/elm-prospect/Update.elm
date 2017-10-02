module Update exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Navigation
import Project.Commands exposing (getProject)
import RemoteData exposing (..)
import Routing exposing (Route(..), parse, toPath)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProjectResponse response ->
            ( { model | project = response }
            , Cmd.none
            )

        UrlChange location ->
            let
                currentRoute =
                    parse location
            in
                urlUpdate { model | route = currentRoute }

        ProjectToStep route ->
            let
                newModel =
                    { model | projectStepAnimation = EnterRight, projectAnimation = None }
            in
                update (NavigateTo route) newModel

        StepToProject route ->
            let
                newModel =
                    { model | projectStepAnimation = None, projectAnimation = EnterLeft }
            in
                update (NavigateTo route) newModel

        NavigateTo route ->
            model ! [ Navigation.newUrl <| toPath route ]


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        ProjectRoute projectId ->
            ( model, getProject model.apiToken projectId )

        ProjectStepRoute projectId projectStep ->
            ( model, getProject model.apiToken projectId )

        _ ->
            ( model, Cmd.none )
