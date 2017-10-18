module LandList.Commands exposing (..)

import Commands exposing (authGet)
import Http
import LandList.Decoders exposing (landListDecoder)
import Messages exposing (Msg(..))
import Model exposing (..)
import Model exposing (ApiToken)
import RemoteData exposing (..)


getLandList : Model -> Cmd Msg
getLandList model =
    let
        url =
            String.concat [ "/api/lands" ]
    in
        authGet model.apiToken url landListDecoder
            |> RemoteData.sendRequest
            |> Cmd.map LandListResponse
