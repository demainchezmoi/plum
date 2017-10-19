module Update exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Routing exposing (Route(..), parse, toPath)
import Navigation
import Land.Commands exposing (ensureLand)
import Land.Model exposing (validation)
import LandList.Commands exposing (getLandList)
import RemoteData exposing (..)
import Form exposing (Form)
import Form.Validate as Validate exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LandResponse response ->
            { model | land = response } ! []

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

        FormMsg formMsg ->
            ( { model | landForm = Form.update validation formMsg model.landForm }, Cmd.none )


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        LandShowRoute landId ->
            { model | land = Loading } ! [ ensureLand model landId ]

        LandListRoute ->
            { model | landList = Loading } ! [ getLandList model ]

        _ ->
            ( model, Cmd.none )
