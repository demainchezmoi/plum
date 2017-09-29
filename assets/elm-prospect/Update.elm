module Update exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Routing exposing (Route(..), parse, toPath)
import Navigation
import Commands exposing (getProject)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProjectResponse response ->
            ( { model | project = response }
            , Cmd.none
            )

        UrlChange location ->
            let
                currentRoute =
                    parse location
            in
                urlUpdate { model | route = currentRoute }

        NavigateTo route ->
            model ! [ Navigation.newUrl <| toPath route ]


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        ProjectRoute projectId ->
            ( model, getProject model.apiToken projectId )

        _ ->
            ( model, Cmd.none )
