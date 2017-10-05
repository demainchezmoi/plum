module Update exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Navigation
import Project.Commands exposing (getProject, updateProject, updateProjectWithCallback)
import RemoteData exposing (..)
import Routing exposing (Route(..), parse, toPath)
import Project.Model exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProjectResponse response ->
            { model | project = response } ! []

        UpdateProject projectId value ->
            model ! [ updateProject model.apiToken projectId value ]

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

        SetHouseColor color ->
            { model | houseColor = color } ! []

        ValidateDiscoverLand projectId value ->
            model ! [ updateProjectWithCallback model.apiToken projectId value ValidateDiscoverLandResponse ]

        ValidateDiscoverLandResponse response ->
            let
                newModel =
                    { model | project = response }
            in
                case response of
                    Success project ->
                        update (NavigateTo (ProjectStepRoute project.id DiscoverHouse)) newModel

                    _ ->
                        newModel ! []

        ValidateDiscoverHouse projectId value ->
            model ! [ updateProjectWithCallback model.apiToken projectId value ValidateDiscoverHouseResponse ]

        ValidateDiscoverHouseResponse response ->
            let
                newModel =
                    { model | project = response }
            in
                case response of
                    Success project ->
                        update (NavigateTo (ProjectStepRoute project.id ConfigureHouse)) newModel

                    _ ->
                        newModel ! []



{--
           - ValidateConfigureHouse
           - ValidateConfigureHouseResponse
           --}


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
