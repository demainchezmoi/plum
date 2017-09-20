module Main exposing (..)

import Commands exposing (fetch)
import Html
import Messages exposing (Msg(..))
import Model exposing (..)
import Update exposing (..)
import View exposing (view)


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        { apiToken } =
            flags
    in
        initialModel apiToken ! [ fetch apiToken ]


main : Program Flags Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = always <| Sub.none
        }
