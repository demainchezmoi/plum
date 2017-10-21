module Update exposing (..)

import Messages exposing (..)
import Model exposing (..)
import Routing exposing (Route(..), parse, toPath)
import Navigation
import Land.Commands exposing (..)
import Land.Model exposing (..)
import LandList.Commands exposing (..)
import LandList.Model exposing (..)
import Land.Encoders exposing (..)
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

        LandCreateResponse response ->
            case response of
                Success land ->
                    (model
                        |> setLand response
                        |> setRoute (LandShowRoute land.id)
                    )
                        ! []

                _ ->
                    model ! []

        UrlChange location ->
            model
                |> setRoute (parse location)
                |> urlUpdate

        NavigateTo route ->
            model ! [ Navigation.newUrl <| toPath route ]

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


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        LandShowRoute landId ->
            { model | land = Loading } ! [ ensureLand model landId ]

        LandListRoute ->
            { model | landList = Loading } ! [ getLandList model ]

        _ ->
            ( model, Cmd.none )


setRoute : Route -> Model -> Model
setRoute route model =
    { model | route = route }


setLand : WebData Land -> Model -> Model
setLand response model =
    { model | land = response }


setLandList : WebData LandList -> Model -> Model
setLandList response model =
    { model | landList = response }
