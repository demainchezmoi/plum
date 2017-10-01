module Project.Commands exposing (..)

import Commands exposing (authGet)
import Decoders exposing (projectDecoder)
import Model exposing (ApiToken)
import Project.Model exposing (ProjectId)
import Messages exposing (Msg(..))
import RemoteData exposing (..)


getProject : ApiToken -> ProjectId -> Cmd Msg
getProject apiToken projectId =
    let
        url =
            "/api/projects/" ++ projectId
    in
        authGet apiToken url projectDecoder
            |> RemoteData.sendRequest
            |> Cmd.map ProjectResponse
