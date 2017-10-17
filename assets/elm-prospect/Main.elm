module Main exposing (..)

import Html
import Messages exposing (Msg(..))
import Model exposing (..)
import Update exposing (..)
import View exposing (view)
import Navigation
import Routing exposing (parse)
import Project.Commands exposing (getProject)
import Bootstrap.Carousel as Carousel


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
        model ! [ urlCmd ]


main : Program Flags Model Msg
main =
    Navigation.programWithFlags UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Carousel.subscriptions model.discoverHouseCarouselState CarouselMsg
