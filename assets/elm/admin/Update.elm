module Update exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Routing exposing (Route(..), parse, toPath)
import Navigation


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LandListResponse response ->
            ( { model | landList = response }
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
        LandsRoute ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
