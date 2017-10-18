module Project.Commands exposing (..)

import Commands exposing (authGet, authPut)
import Model exposing (..)
import Json.Encode exposing (..)
import Messages exposing (Msg(..))
import Project.Decoders exposing (projectDecoder)
import Project.Encoders exposing (projectEncoder)
import Project.Model exposing (ProjectId, Project)
import RemoteData exposing (..)
import Task


getProjectWithCallback : ApiToken -> ProjectId -> (WebData Project -> Msg) -> Cmd Msg
getProjectWithCallback apiToken projectId callback =
    let
        url =
            "/api/projects/" ++ (toString projectId)
    in
        authGet apiToken url projectDecoder
            |> RemoteData.sendRequest
            |> Cmd.map callback


getProject : ApiToken -> ProjectId -> Cmd Msg
getProject apiToken projectId =
    getProjectWithCallback apiToken projectId ProjectResponse


updateProjectWithCallback : ApiToken -> ProjectId -> Value -> (WebData Project -> Msg) -> Cmd Msg
updateProjectWithCallback apiToken projectId value callback =
    let
        url =
            "/api/projects/" ++ (toString projectId)

        project_data =
            object [ ( "project", value ) ]
    in
        authPut apiToken url projectDecoder project_data
            |> RemoteData.sendRequest
            |> Cmd.map callback


updateProject : ApiToken -> ProjectId -> Value -> Cmd Msg
updateProject apiToken projectId value =
    updateProjectWithCallback apiToken projectId value ProjectResponse


ensureProjectWithCallback : Model -> ProjectId -> (WebData Project -> Msg) -> Cmd Msg
ensureProjectWithCallback model projectId callback =
    if projectIsLoaded model projectId then
        Task.succeed (callback model.project)
            |> Task.perform identity
    else
        getProjectWithCallback model.apiToken projectId callback


ensureProject : Model -> ProjectId -> Cmd Msg
ensureProject model projectId =
    ensureProjectWithCallback model projectId ProjectResponse


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
