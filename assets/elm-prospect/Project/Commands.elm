module Project.Commands exposing (..)

import Commands exposing (authGet, authPut)
import Json.Encode exposing (..)
import Messages exposing (Msg(..))
import Model exposing (ApiToken)
import Project.Decoders exposing (projectDecoder)
import Project.Encoders exposing (projectEncoder)
import Project.Model exposing (ProjectId, Project)
import RemoteData exposing (..)


getProject : ApiToken -> ProjectId -> Cmd Msg
getProject apiToken projectId =
    let
        url =
            "/api/projects/" ++ (toString projectId)
    in
        authGet apiToken url projectDecoder
            |> RemoteData.sendRequest
            |> Cmd.map ProjectResponse


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
