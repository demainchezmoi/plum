module Update exposing (..)

import Bootstrap.Carousel as Carousel
import Commands exposing (getMaybeValue)
import Json.Encode as Encode
import Land.Model exposing (coordinatesFromLand)
import Messages exposing (..)
import Model exposing (..)
import Navigation
import Ports exposing (..)
import Project.Commands exposing (..)
import Project.Model exposing (..)
import RemoteData exposing (..)
import Routing exposing (Route(..), parse, toPath)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        ProjectResponse response ->
            setProject response model ! []

        DiscoverHouseProjectResponse response ->
            let
                newModel =
                    model |> setProject response
            in
                case response of
                    Success project ->
                        newModel ! [ loadCarousel () ]

                    _ ->
                        newModel ! []

        DiscoverLandProjectResponse response ->
            let
                newModel =
                    model |> setProject response
            in
                case response of
                    Success project ->
                        let
                            coordinates =
                                coordinatesFromLand project.ad.land
                        in
                            newModel ! [ landMap coordinates ]

                    _ ->
                        newModel ! []

        UpdateProject projectId value ->
            model ! [ updateProject model.apiToken projectId value ]

        UrlChange location ->
            let
                currentRoute =
                    parse location
            in
                urlUpdate { model | route = currentRoute }

        NavigateTo route ->
            model ! [ removeLandMap (), Navigation.newUrl <| toPath route ]

        SetContribution contribution ->
            case String.toInt contribution of
                Ok intContribution ->
                    { model | contribution = Just intContribution } ! []

                Err _ ->
                    { model | contribution = Nothing } ! []

        SetNetIncome netIncome ->
            case String.toInt netIncome of
                Ok intNetIncome ->
                    { model | netIncome = Just intNetIncome } ! []

                Err _ ->
                    { model | netIncome = Nothing } ! []

        SetPhoneNumber phoneNumber ->
            { model | phoneNumber = Just phoneNumber } ! []

        ValidateDiscoverHouse projectId value ->
            model
                ! [ updateProjectWithCallback
                        model.apiToken
                        projectId
                        value
                        ValidateDiscoverHouseResponse
                  ]

        ValidateDiscoverHouseResponse response ->
            let
                newModel =
                    model |> setProject response
            in
                case response of
                    Success project ->
                        update
                            (NavigateTo
                                (ProjectStepRoute project.id DiscoverLand)
                            )
                            newModel

                    _ ->
                        newModel ! []

        ValidateDiscoverLand projectId value ->
            model
                ! [ updateProjectWithCallback
                        model.apiToken
                        projectId
                        value
                        ValidateDiscoverLandResponse
                  ]

        ValidateDiscoverLandResponse response ->
            let
                newModel =
                    model |> setProject response
            in
                case response of
                    Success project ->
                        update
                            (NavigateTo
                                (ProjectStepRoute project.id EvaluateFunding)
                            )
                            newModel

                    _ ->
                        newModel ! []

        ValidateEvaluateFunding projectId ->
            let
                value =
                    (getMaybeValue "contribution" model.contribution Encode.int)
                        ++ (getMaybeValue "net_income" model.netIncome Encode.int)
                        |> Encode.object
            in
                model
                    ! [ updateProjectWithCallback
                            model.apiToken
                            projectId
                            value
                            ValidateEvaluateFundingResponse
                      ]

        ValidateEvaluateFundingResponse response ->
            let
                newModel =
                    model |> setProject response
            in
                case response of
                    Success project ->
                        case stepState project EvaluateFunding of
                            Checked ->
                                update
                                    (NavigateTo
                                        (ProjectStepRoute project.id PhoneCall)
                                    )
                                    newModel

                            _ ->
                                newModel ! []

                    _ ->
                        newModel ! []

        SubmitPhoneNumber projectId ->
            case model.phoneNumber of
                Nothing ->
                    model ! []

                Just phoneNumber ->
                    let
                        value =
                            (getMaybeValue "phone_number" model.phoneNumber Encode.string)
                                |> Encode.object
                    in
                        model
                            ! [ updateProjectWithCallback
                                    model.apiToken
                                    projectId
                                    value
                                    SubmitPhoneNumberResponse
                              ]

        SubmitPhoneNumberResponse response ->
            setProject response model ! []

        CarouselMsg subMsg ->
            { model
                | discoverHouseCarouselState =
                    Carousel.update subMsg model.discoverHouseCarouselState
            }
                ! []


urlUpdate : Model -> ( Model, Cmd Msg )
urlUpdate model =
    case model.route of
        ProjectRoute projectId ->
            model
                ! [ ensureProject model projectId
                  , mixpanel
                        ( "PROJECT"
                        , Encode.object [ ( "id", projectId |> toString |> Encode.string ) ]
                        )
                  ]

        ProjectStepRoute projectId DiscoverHouse ->
            model
                ! [ ensureProjectWithCallback model projectId DiscoverHouseProjectResponse
                  , mixpanel
                        ( "PROJECT_STEP"
                        , Encode.object [ ( "step", DiscoverHouse |> toString |> Encode.string ) ]
                        )
                  ]

        ProjectStepRoute projectId DiscoverLand ->
            model
                ! [ ensureProjectWithCallback model projectId DiscoverLandProjectResponse
                  , mixpanel
                        ( "PROJECT_STEP"
                        , Encode.object [ ( "step", DiscoverLand |> toString |> Encode.string ) ]
                        )
                  ]

        ProjectStepRoute projectId projectStep ->
            model
                ! [ ensureProject model projectId
                  , mixpanel
                        ( "PROJECT_STEP"
                        , Encode.object [ ( "step", projectStep |> toString |> Encode.string ) ]
                        )
                  ]

        _ ->
            model ! [ Cmd.none ]


setProject : WebData Project -> Model -> Model
setProject response model =
    case response of
        Success project ->
            { model
                | project = response
                , netIncome = project.net_income
                , contribution = project.contribution
                , phoneNumber = project.phone_number
            }

        _ ->
            { model | project = response }
