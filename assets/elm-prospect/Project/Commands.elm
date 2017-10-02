module Project.Commands exposing (..)

import Commands exposing (authGet)
import Messages exposing (Msg(..))
import Model exposing (ApiToken)
import Project.Decoders exposing (projectDecoder)
import Project.Model exposing (ProjectId)
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
