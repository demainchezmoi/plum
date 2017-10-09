module Project.View exposing (..)

import Ad.Model exposing (Ad)
import Ad.View as AdView
import Html exposing (..)
import Html.Attributes exposing (class, src, type_, name, value, id, checked, for, placeholder, style)
import Html.Events exposing (onClick, onInput)
import Json.Encode
import Land.Model exposing (Land)
import Maps
import Maps.Geo
import Maps.Map as Map
import Maps.Marker as Marker
import Messages exposing (..)
import Model exposing (..)
import Project.Model exposing (..)
import RemoteData exposing (..)
import Routing exposing (toPath, Route(..))
import ViewHelpers exposing (..)


projectPageView : Model -> Html Msg
projectPageView model =
    case model.project of
        Failure err ->
            failureView err |> inLayout

        NotAsked ->
            notAskedView |> inLayout

        Loading ->
            loadingView |> inLayout

        Success project ->
            projectView model project |> inLayout


projectHeader : Project -> Html Msg
projectHeader project =
    div [ class "media light-bordered p-3" ]
        [ img [ class "d-flex mr-3 img-thumbnail", src "https://s3-eu-west-1.amazonaws.com/demainchezmoi/cloudfront_assets/images/maison_21.png", style [ ( "width", "100px" ) ] ] []
        , div [ class "media-body" ]
            [ h5 [ class "mt-0 default-color-text" ]
                [ text "Mon espace"
                ]
            , AdView.shortView project.ad
            ]
        ]


projectView : Model -> Project -> Html Msg
projectView model project =
    div []
        [ projectHeader project
        , div [ class "mt-2 mb-5" ]
            [ ul [ class "list-group" ]
                (List.map (\dStep -> stepIndexView dStep.step model project dStep.label) displaySteps)
            ]
        ]


projectStepPageView : ProjectStep -> Model -> Html Msg
projectStepPageView projectStep model =
    case model.project of
        Failure err ->
            failureView err |> inLayout

        NotAsked ->
            notAskedView |> inLayout

        Loading ->
            loadingView |> inLayout

        Success project ->
            case List.filter (\dStep -> dStep.step == projectStep) displaySteps of
                dStep :: _ ->
                    dStep.view model project dStep.label |> inLayout

                _ ->
                    text "Erreur" |> inLayout


type alias DisplayStep =
    { step : ProjectStep
    , view : Model -> Project -> String -> Html Msg
    , label : String
    }


displaySteps : List DisplayStep
displaySteps =
    [ { step = Welcome, view = welcomeView, label = "Bienvenue" }
    , { step = DiscoverLand, view = discoverLandView, label = "Découvrir le terrain" }
    , { step = DiscoverHouse, view = discoverHouseView, label = "Découvrir la maison" }
    , { step = ConfigureHouse, view = configureHouseView, label = "Mon choix de couleurs" }
    , { step = EvaluateFunding, view = evaluateFundingView, label = "Ma finançabilité" }
    , { step = PhoneCall, view = phoneCallView, label = "Premier contact" }
    , { step = Quotation, view = quotationView, label = "Mon devis" }
    , { step = Funding, view = fundingView, label = "Mon financement" }
    , { step = VisitLand, view = visitLandView, label = "Visite du terrain" }
    , { step = Contract, view = contractView, label = "Signature du contrat" }
    , { step = Permit, view = permitView, label = "Permis de construire" }
    , { step = Building, view = buildingView, label = "Construction" }
    , { step = Keys, view = keysView, label = "Réception" }
    , { step = AfterSales, view = afterSalesView, label = "Après-vente" }
    ]


checkedIcon : ProjectStepStatus -> Html Msg
checkedIcon state =
    let
        checkedIcon =
            span [ class "fa-stack mr-2" ]
                [ i [ class "fa fa-circle fa-stack-2x yellow-flash-text black-bordered-icon" ] []
                , i [ class "fa fa-check fa-stack-1x" ] []
                ]

        currentIcon =
            span [ class "fa-stack mr-2" ]
                [ i [ class "fa fa-circle fa-stack-2x" ] []
                , i [ class "fa fa-arrow-right fa-stack-1x fa-inverse" ] []
                ]

        notYetIcon =
            span [ class "fa-stack mr-2 text-secondary" ]
                [ i [ class "fa fa-circle fa-stack-2x" ] []
                , i [ class "fa fa-question fa-stack-1x fa-inverse" ] []
                ]
    in
        case state of
            Checked ->
                checkedIcon

            Current ->
                currentIcon

            NotYet ->
                notYetIcon


stepIndexView : ProjectStep -> Model -> Project -> String -> Html Msg
stepIndexView projectStep model project label =
    let
        activeAttr =
            [ onClick (NavigateTo (ProjectStepRoute project.id projectStep)), class "list-group-item cp gray-hover" ]

        liAttr =
            case stepState project projectStep of
                Checked ->
                    activeAttr

                Current ->
                    activeAttr

                NotYet ->
                    [ class "list-group-item disabled" ]
    in
        li liAttr
            [ a []
                [ checkedIcon (stepState project projectStep)
                , label |> text
                ]
            ]


stepInfo : String -> Html Msg
stepInfo desc =
    p [ class "text-secondary text-bold" ] [ text desc ]


stepView : Model -> Project -> String -> Html Msg -> Html Msg
stepView model project title view =
    div []
        [ h1 [ class "h1-responsive" ]
            [ a
                [ class "btn btn-sm btn-yellow-flash"
                , onClick (NavigateTo (ProjectRoute project.id))
                ]
                [ i [ class "fa fa-chevron-left" ] []
                ]
            , text title
            ]
        , view
        ]


nextStepButton : Msg -> Html Msg
nextStepButton action =
    div [ class "clearfix" ]
        [ button
            [ class "btn btn-default pull-right mr-0 mt-2", onClick action ]
            [ text "Suivant" ]
        ]


landImage : String -> Html Msg
landImage source =
    img [ class "d-block p-2 img-thumbnail mt-2 img-fluid w-100", src source ] []


projectLandImages : Project -> List (Html Msg)
projectLandImages project =
    List.map landImage project.ad.land.images


landMap : Model -> Html Msg
landMap model =
    div [ class "light-bordered p-2 w-100 map mt-2" ] [ Maps.view model.landMap |> Maps.mapView MapsMsg ]


welcomeView : Model -> Project -> String -> Html Msg
welcomeView model project title =
    let
        text1 =
            "Bienvenue dans votre espace Maisons Léo."

        text2 =
            "Cet espace vous permet de gérer votre candidature pour l'annonce maison plus terrain à "
                ++ project.ad.land.city
                ++ " "
                ++ "("
                ++ project.ad.land.department
                ++ ")"
                ++ "."

        text3 =
            "Passez les étapes pour découvrir le terrain, la maison, choisir vos couleurs ... et ainsi de suite jusqu'à l'obtention de vos clefs !"

        button =
            (NavigateTo (ProjectStepRoute project.id DiscoverLand)) |> nextStepButton

        view =
            div []
                [ p [] [ text text1 ]
                , p [] [ text text2 ]
                , p [] [ text text3 ]
                , button
                ]
    in
        stepView model project title view


discoverLandView : Model -> Project -> String -> Html Msg
discoverLandView model project title =
    let
        updateValue =
            Json.Encode.object [ ( "discover_land", Json.Encode.bool True ) ]

        getButton : Html Msg
        getButton =
            ValidateDiscoverLand project.id updateValue |> nextStepButton

        button =
            case stepState project DiscoverLand of
                Checked ->
                    getButton

                Current ->
                    getButton

                NotYet ->
                    text ""

        view =
            div []
                ([ stepInfo "Découvrez le terrain et ses environs." ]
                    -- ++ (projectLandImages project)
                    ++ [ landMap model ]
                    ++ [ p [ class "mt-2 p-3 light-bordered" ] [ text project.ad.land.description ]
                       , button
                       ]
                )
    in
        stepView model project title view


discoverHouseView : Model -> Project -> String -> Html Msg
discoverHouseView model project title =
    let
        updateValue =
            Json.Encode.object [ ( "discover_house", Json.Encode.bool True ) ]

        getButton : Html Msg
        getButton =
            ValidateDiscoverHouse project.id updateValue |> nextStepButton

        button =
            case stepState project DiscoverHouse of
                Checked ->
                    getButton

                Current ->
                    getButton

                NotYet ->
                    text ""

        view =
            div []
                [ stepInfo "Découvrez la maison Léo"
                , photo "maison_21_nuit.jpg"
                , photo "maison-min.png"
                , button
                ]
    in
        stepView model project title view


configureHouseView : Model -> Project -> String -> Html Msg
configureHouseView model project title =
    let
        color1 =
            "Maison-leo-configurateur-1.png"

        color2 =
            "Maison-leo-configurateur-2.png"

        ( photo1, checked11, checked12 ) =
            case ( model.houseColor1, project.house_color_1 ) of
                ( Just house_color_1, _ ) ->
                    ( [ photoClass house_color_1 "photo-stack" ], house_color_1 == color1, house_color_1 == color2 )

                ( Nothing, Just house_color_1 ) ->
                    ( [ photoClass house_color_1 "photo-stack" ], house_color_1 == color1, house_color_1 == color2 )

                _ ->
                    ( [], False, False )

        ( photo2, checked21, checked22 ) =
            case ( model.houseColor2, project.house_color_2 ) of
                ( Just house_color_2, _ ) ->
                    ( [ photoClass house_color_2 "photo-stack" ], house_color_2 == color1, house_color_2 == color2 )

                ( Nothing, Just house_color_2 ) ->
                    ( [ photoClass house_color_2 "photo-stack" ], house_color_2 == color1, house_color_2 == color2 )

                _ ->
                    ( [], False, False )

        view =
            div []
                [ stepInfo "Choisissez les enduits de votre maison Léo, en une ou deux couleurs."
                , div [ class "position-relative" ]
                    ([ photo "Maison-leo-configurateur-0-min.png" ] ++ photo1 ++ photo2)
                , div [ class "light-bordered p-3 mt-2" ]
                    [ row
                        [ div [ class "col-6" ]
                            [ p [ class "font-bold" ] [ text "Choix 1" ]
                            , div [ class "form-check" ]
                                [ label [ class "form-check-label" ]
                                    [ input
                                        [ type_ "radio"
                                        , name "house-color-1"
                                        , value color1
                                        , id "house-color-11"
                                        , class "form-check-input"
                                        , checked checked11
                                        , onClick (SetHouseColor1 color1)
                                        ]
                                        []
                                    , text "couleur-1"
                                    ]
                                ]
                            , div [ class "form-check" ]
                                [ label [ class "form-check-label" ]
                                    [ input
                                        [ type_ "radio"
                                        , name "house-color-1"
                                        , value color2
                                        , id "house-color-12"
                                        , class "form-check-input"
                                        , checked checked12
                                        , onClick (SetHouseColor1 color2)
                                        ]
                                        []
                                    , text "couleur-2"
                                    ]
                                ]
                            ]
                        , div [ class "col-6" ]
                            [ p [ class "font-bold" ] [ text "Choix 2" ]
                            , div [ class "form-check" ]
                                [ label [ class "form-check-label" ]
                                    [ input
                                        [ type_ "radio"
                                        , name "house-color-2"
                                        , value color1
                                        , id "house-color-21"
                                        , class "form-check-input"
                                        , checked checked21
                                        , onClick (SetHouseColor2 color1)
                                        ]
                                        []
                                    , text "couleur-1"
                                    ]
                                ]
                            , div [ class "form-check" ]
                                [ label [ class "form-check-label" ]
                                    [ input
                                        [ type_ "radio"
                                        , name "house-color-2"
                                        , value color2
                                        , id "house-color-22"
                                        , class "form-check-input"
                                        , checked checked22
                                        , onClick (SetHouseColor2 color2)
                                        ]
                                        []
                                    , text "couleur-2"
                                    ]
                                ]
                            ]
                        ]
                    ]
                , ValidateConfigureHouse project.id |> nextStepButton
                ]
    in
        stepView model project title view


evaluateFundingView : Model -> Project -> String -> Html Msg
evaluateFundingView model project title =
    let
        contributionValue =
            case model.contribution of
                Just contribution ->
                    toString contribution

                Nothing ->
                    ""

        netIncomeValue =
            case model.netIncome of
                Just netIncome ->
                    toString netIncome

                Nothing ->
                    ""

        view =
            div []
                [ stepInfo "Pour mener à bien votre projet de construction, nous allons vous aider à trouver un financement."
                , div [ class "p-1" ]
                    [ div [ class "form-group" ]
                        [ label [ for "contribution" ] [ text "Votre apport financier (€)" ]
                        , input
                            [ type_ "number"
                            , class "form-control"
                            , id "contribution"
                            , placeholder "ex : 7000"
                            , onInput SetContribution
                            , value contributionValue
                            ]
                            []
                        ]
                    , div [ class "form-group" ]
                        [ label [ for "netIncome" ] [ text "Revenu mensuel net de votre ménage (€)" ]
                        , input
                            [ type_ "number"
                            , class "form-control"
                            , id "netIncome"
                            , placeholder "ex : 1800"
                            , onInput SetNetIncome
                            , value netIncomeValue
                            ]
                            []
                        ]
                    ]
                , ValidateEvaluateFunding project.id |> nextStepButton
                ]
    in
        stepView model project title view


phoneCallView : Model -> Project -> String -> Html Msg
phoneCallView model project title =
    let
        phoneNumberValue =
            case model.phoneNumber of
                Just phoneNumber ->
                    phoneNumber

                Nothing ->
                    ""

        view =
            div []
                [ stepInfo "Discutons de votre project ! Indiquez-nous votre numéro de téléphone et nous prendrons contact avec vous pour vous accompagner."
                , div [ class "form-group" ]
                    [ label [ for "phoneNumber" ] [ text "Votre numéro de téléphone" ]
                    , input
                        [ type_ "text"
                        , class "form-control"
                        , id "phoneNumber"
                        , placeholder "ex : 06 03 05 04 01"
                        , onInput SetPhoneNumber
                        , value phoneNumberValue
                        ]
                        []
                    ]
                , SubmitPhoneNumber project.id |> nextStepButton
                ]
    in
        stepView model project title view


quotationView : Model -> Project -> String -> Html Msg
quotationView model project title =
    let
        view =
            div [] []
    in
        stepView model project title view


fundingView : Model -> Project -> String -> Html Msg
fundingView model project title =
    let
        view =
            div [] []
    in
        stepView model project title view


visitLandView : Model -> Project -> String -> Html Msg
visitLandView model project title =
    let
        view =
            div [] []
    in
        stepView model project title view


contractView : Model -> Project -> String -> Html Msg
contractView model project title =
    let
        view =
            div [] []
    in
        stepView model project title view


permitView : Model -> Project -> String -> Html Msg
permitView model project title =
    let
        view =
            div [] []
    in
        stepView model project title view


buildingView : Model -> Project -> String -> Html Msg
buildingView model project title =
    let
        view =
            div [] []
    in
        stepView model project title view


keysView : Model -> Project -> String -> Html Msg
keysView model project title =
    let
        view =
            div [] []
    in
        stepView model project title view


afterSalesView : Model -> Project -> String -> Html Msg
afterSalesView model project title =
    let
        view =
            div [] []
    in
        stepView model project title view
