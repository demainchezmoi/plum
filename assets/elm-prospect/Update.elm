module Update exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Navigation
import Project.Commands exposing (getProject, updateProject)
import RemoteData exposing (..)
import Routing exposing (Route(..), parse, toPath)
import Project.Model exposing (ProjectId)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProjectResponse response ->
            ( { model | project = response }
            , Cmd.none
            )

        UpdateProject project ->
            model ! [ updateProject model.apiToken project.id project ]

        UrlChange location ->
            let
                currentRoute =
                    parse location
            in
                urlUpdate { model | route = currentRoute }

        ProjectToStep route ->
            let
                newModel =
                    { model | projectStepAnimation = None, projectAnimation = None }
            in
                update (NavigateTo route) newModel

        StepToProject route ->
            let
                newModel =
                    { model | projectStepAnimation = None, projectAnimation = None }
            in
                update (NavigateTo route) newModel

        NavigateTo route ->
            model ! [ Navigation.newUrl <| toPath route ]


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        ProjectRoute projectId ->
            ( model, ensureProject model projectId )

        ProjectStepRoute projectId projectStep ->
            ( model, ensureProject model projectId )

        _ ->
            ( model, Cmd.none )


ensureProject : Model -> ProjectId -> Cmd Msg
ensureProject model projectId =
    if projectIsLoaded model projectId then
        Cmd.none
    else
        getProject model.apiToken projectId


projectIsLoaded : Model -> ProjectId -> Bool
projectIsLoaded model projectId =
    case model.project of
        Success project ->
            if project.id == projectId then
                True
            else
                False

        _ ->
            False
