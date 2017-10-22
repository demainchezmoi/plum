module Update exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Routing exposing (Route(..), parse, toPath)
import Navigation
import Land.Commands exposing (..)
import Land.Model exposing (..)
import Land.Encoders exposing (..)
import Land.Form exposing (..)
import RemoteData exposing (..)
import Form exposing (Form)
import Form.Validate as Validate exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        LandResponse response ->
            (model
                |> setLand response
            )
                ! []

        LandListResponse response ->
            (model
                |> setLandList response
            )
                ! []

        LandFormMsg formMsg ->
            let
                landForm =
                    Form.update landFormValidation formMsg model.landForm

                newModel =
                    { model | landForm = landForm }

                cmd =
                    case ( formMsg, Form.getOutput landForm ) of
                        ( Form.Submit, Just landForm ) ->
                            [ createLand model.apiToken (landFormEncoder landForm) ]

                        _ ->
                            []
            in
                newModel ! cmd

        LandCreateResponse response ->
            case response of
                Success land ->
                    model
                        |> setLand response
                        |> navigateTo (LandShowRoute land.id)

                _ ->
                    model ! []

        UrlChange location ->
            model
                |> setRoute (parse location)
                |> urlUpdate

        NavigateTo route ->
            model
                |> navigateTo route


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        LandShowRoute landId ->
            { model | land = Loading } ! [ ensureLand model landId ]

        LandListRoute ->
            { model | landList = Loading } ! [ getLandList model ]

        _ ->
            ( model, Cmd.none )


navigateTo : Route -> Model -> ( Model, Cmd Msg )
navigateTo route model =
    model ! [ Navigation.newUrl <| toPath route ]


setRoute : Route -> Model -> Model
setRoute route model =
    { model | route = route }


setLand : WebData Land -> Model -> Model
setLand response model =
    { model | land = response }


setLandList : WebData LandList -> Model -> Model
setLandList response model =
    { model | landList = response }
