module Commands exposing (..)

import Decoders exposing (landListDecoder)
import Http
import Messages exposing (Msg(..))
import Model exposing (ApiToken)
import RemoteData exposing (..)


getLandList : ApiToken -> Cmd Msg
getLandList apiToken =
    let
        apiUrl =
            String.concat [ "/api/lands/?token=", apiToken ]
    in
        Http.get apiUrl landListDecoder
            |> RemoteData.sendRequest
            |> Cmd.map LandListResponse
