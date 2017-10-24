module Update exposing (..)

import Ad.Model exposing (..)
import DecodedTypes exposing (..)
import Dict
import Messages exposing (..)
import Model exposing (..)
import Routing exposing (Route(..), parse, toPath)
import Navigation
import Land.Commands exposing (..)
import Land.Encoders exposing (..)
import Land.Form exposing (..)
import Land.Model exposing (..)
import RemoteData exposing (..)
import Form exposing (Form)
import Form.Validate as Validate exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        LandResponse landId response ->
            (model |> setDecodedLandWD landId response) ! []

        LandListResponse response ->
            (model |> setDecodedLandsWD response) ! []

        LandEditResponse landId response ->
            (model
                |> setDecodedLandWD landId response
                |> setLandFormWD response
            )
                ! []

        LandCreateResponse response ->
            let
                landResponse =
                    response |> RemoteData.map (\decodedLand -> decodedLand.land)
            in
                case response of
                    Success decodedLand ->
                        model
                            |> setLandWD decodedLand.land.id landResponse
                            |> resetLandForm
                            |> navigateTo (LandShowRoute decodedLand.land.id)

                    _ ->
                        model ! []

        LandUpdateResponse landId response ->
            case response of
                Success _ ->
                    (model
                        |> setDecodedLandWD landId response
                    )
                        |> navigateTo (LandShowRoute landId)

                _ ->
                    model ! []

        LandDelete landId ->
            model ! [ deleteLand model.apiToken landId ]

        LandDeleteResponse landId response ->
            case Debug.log "debug" response of
                Success _ ->
                    { model
                        | lands =
                            model.lands |> Dict.remove landId
                    }
                        |> navigateTo LandListRoute

                _ ->
                    model ! []

        LandFormMsg action formMsg ->
            let
                landForm =
                    Form.update landFormValidation formMsg model.landForm

                newModel =
                    { model | landForm = landForm }

                cmd =
                    case ( action, formMsg, Form.getOutput landForm ) of
                        ( Create, Form.Submit, Just landForm ) ->
                            [ createLand model.apiToken (landFormEncoder landForm) ]

                        ( Update landId, Form.Submit, Just landForm ) ->
                            [ updateLand model.apiToken landId (landFormEncoder landForm) ]

                        _ ->
                            []
            in
                newModel ! cmd

        UrlChange location ->
            model
                |> setRoute (parse location)
                |> urlUpdate

        NavigateTo route ->
            model
                |> navigateTo route



-- Navigation


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        LandShowRoute landId ->
            (model
                |> setLandWD landId Loading
            )
                ! [ ensureLand landId model ]

        LandListRoute ->
            model ! [ getLandList model ]

        LandEditRoute landId ->
            (model
                |> setLandWD landId Loading
            )
                ! [ ensureLandWithCallback landId model LandEditResponse ]

        _ ->
            ( model, Cmd.none )


navigateTo : Route -> Model -> ( Model, Cmd Msg )
navigateTo route model =
    model ! [ Navigation.newUrl <| toPath route ]


setRoute : Route -> Model -> Model
setRoute route model =
    { model | route = route }



-- Decoded Lands


setDecodedLandWD : Int -> WebData DecodedLand -> Model -> Model
setDecodedLandWD landId response model =
    let
        landResponse =
            response |> RemoteData.map (\decodedLand -> decodedLand.land)

        ads =
            case response of
                Success decodedLand ->
                    decodedLand.ads

                _ ->
                    []
    in
        model
            |> setLandWD landId landResponse
            |> setAds ads


setDecodedLandsWD : WebData (List DecodedLand) -> Model -> Model
setDecodedLandsWD decodedLandsWD model =
    case decodedLandsWD of
        Success decodedLands ->
            model |> setDecodedLands decodedLands

        _ ->
            model


setDecodedLands : List DecodedLand -> Model -> Model
setDecodedLands decodedLands model =
    case decodedLands of
        [] ->
            model

        decodedLand :: rest ->
            setDecodedLands rest (model |> setDecodedLandWD decodedLand.land.id (Success decodedLand))



-- Land Form


setLandFormWD : WebData DecodedLand -> Model -> Model
setLandFormWD response model =
    case response of
        Success decodedLand ->
            setLandForm decodedLand model

        _ ->
            model


setLandForm : DecodedLand -> Model -> Model
setLandForm decodedLand model =
    { model
        | landForm =
            Form.initial
                (decodedLand.land
                    |> landToLandForm
                    |> landFormToGroup
                )
                landFormValidation
    }


resetLandForm : Model -> Model
resetLandForm model =
    { model | landForm = initialLandForm }



-- Lands


setLandWD : Int -> WebData Land -> Model -> Model
setLandWD landId response model =
    { model | lands = model.lands |> Dict.insert landId response }


setLand : Int -> Land -> Model -> Model
setLand landId land model =
    model |> setLandWD land.id (RemoteData.succeed land)


setLands : List Land -> Model -> Model
setLands lands model =
    case lands of
        [] ->
            model

        land :: rest ->
            setLands rest (setLand land.id land model)



-- Ads


setAdWD : Int -> WebData Ad -> Model -> Model
setAdWD adId response model =
    { model | ads = model.ads |> Dict.insert adId response }


setAd : Int -> Ad -> Model -> Model
setAd adId ad model =
    model |> setAdWD ad.id (RemoteData.succeed ad)


setAds : List Ad -> Model -> Model
setAds ads model =
    case ads of
        [] ->
            model

        ad :: rest ->
            setAds rest (setAdWD ad.id (RemoteData.succeed ad) model)
