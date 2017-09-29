module Commands exposing (..)

import Decoders exposing (projectDecoder)
import Http
import Messages exposing (Msg(..))
import Model exposing (ApiToken)
import RemoteData exposing (..)
import Project.Model exposing (ProjectId)


getProject : ApiToken -> ProjectId -> Cmd Msg
getProject apiToken projectId =
    let
        apiUrl =
            String.concat [ "/api/project/", projectId, "/?token=", apiToken ]
    in
        Http.get apiUrl projectDecoder
            |> RemoteData.sendRequest
            |> Cmd.map ProjectResponse
