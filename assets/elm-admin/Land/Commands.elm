module Land.Commands exposing (..)

import Commands exposing (..)
import Json.Encode exposing (..)
import Messages exposing (Msg(..))
import Model exposing (..)
import Land.Decoders exposing (landDecoder, landShowDecoder)
import Land.Model exposing (Land, LandId)
import RemoteData exposing (..)
import Task


getLandWithCallback : ApiToken -> LandId -> (WebData Land -> Msg) -> Cmd Msg
getLandWithCallback apiToken landId callback =
    let
        url =
            "/api/lands/" ++ (toString landId)
    in
        authGet apiToken url landShowDecoder
            |> RemoteData.sendRequest
            |> Cmd.map callback


getLand : ApiToken -> LandId -> Cmd Msg
getLand apiToken landId =
    getLandWithCallback apiToken landId LandResponse


createLandWithCallback : ApiToken -> Value -> (WebData Land -> Msg) -> Cmd Msg
createLandWithCallback apiToken landFormValue callback =
    let
        url =
            "/api/lands"

        land_data =
            object [ ( "land", landFormValue ) ]
    in
        authPost apiToken url landDecoder land_data
            |> RemoteData.sendRequest
            |> Cmd.map callback


createLand : ApiToken -> Value -> Cmd Msg
createLand apiToken landFormValue =
    createLandWithCallback apiToken landFormValue CreateLandResponse


ensureLandWithCallback : Model -> LandId -> (WebData Land -> Msg) -> Cmd Msg
ensureLandWithCallback model landId callback =
    if landIsLoaded model landId then
        Task.succeed (callback model.land)
            |> Task.perform identity
    else
        getLandWithCallback model.apiToken landId callback


ensureLand : Model -> LandId -> Cmd Msg
ensureLand model landId =
    ensureLandWithCallback model landId LandResponse


landIsLoaded : Model -> LandId -> Bool
landIsLoaded model landId =
    case model.land of
        Success land ->
            if land.id == landId then
                True
            else
                False

        _ ->
            False
