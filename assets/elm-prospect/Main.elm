module Main exposing (..)

import Html
import Messages exposing (Msg(..))
import Model exposing (..)
import Navigation
import Project.Commands exposing (getProject)
import Routing exposing (parse)
import Task
import Update exposing (..)
import View exposing (view)
import Window


defaultSize : Window.Size
defaultSize =
    Window.Size 500 500


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        { apiToken } =
            flags

        currentRoute =
            parse location

        ( model, urlCmd ) =
            urlUpdate (initialModel apiToken currentRoute)
    in
        model ! [ urlCmd, Task.attempt (Result.withDefault defaultSize >> Resize) Window.size ]


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.batch [ Window.resizes Resize ]
        }
