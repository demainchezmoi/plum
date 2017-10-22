module Update exposing (..)

import Dict
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

        LandResponse landId response ->
            (model
                |> setLand landId response
            )
                ! []

        LandListResponse response ->
            case response of
                Success lands ->
                    (model
                        |> setLands lands
                    )
                        ! []

                _ ->
                    model ! []

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
                        |> setLand land.id response
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
            (model
                |> setLand landId Loading
            )
                ! [ ensureLand landId model ]

        LandListRoute ->
            model ! [ getLandList model ]

        _ ->
            ( model, Cmd.none )


navigateTo : Route -> Model -> ( Model, Cmd Msg )
navigateTo route model =
    model ! [ Navigation.newUrl <| toPath route ]


setRoute : Route -> Model -> Model
setRoute route model =
    { model | route = route }


setLand : Int -> WebData Land -> Model -> Model
setLand landId response model =
    { model | lands = Dict.insert landId response model.lands }


setLands : List Land -> Model -> Model
setLands lands model =
    case lands of
        [] ->
            model

        land :: rest ->
            setLands rest (setLand land.id (Success land) model)
