module LandList.Commands exposing (..)

import Commands exposing (authGet)
import Http
import LandList.Decoders exposing (landListDecoder)
import Messages exposing (Msg(..))
import Model exposing (ApiToken)
import RemoteData exposing (..)


getLandList : ApiToken -> Cmd Msg
getLandList apiToken =
    let
        url =
            String.concat [ "/api/lands" ]
    in
        authGet apiToken url landListDecoder
            |> RemoteData.sendRequest
            |> Cmd.map LandListResponse
