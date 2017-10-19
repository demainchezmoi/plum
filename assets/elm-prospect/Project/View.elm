module Project.View exposing (..)

import Ad.Model as AdModel exposing (Ad)
import Ad.View as AdView
import Bootstrap.Card as Card
import Bootstrap.Carousel as Carousel
import Bootstrap.Carousel.Slide as Slide
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (frenchLocale)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Encode
import Land.Model exposing (Land)
import Messages exposing (..)
import Model exposing (..)
import Project.Model exposing (..)
import RemoteData exposing (..)
import Routing exposing (toPath, Route(..))
import ViewHelpers exposing (..)


inLayout : Html Msg -> Html Msg -> Html Msg
inLayout nav elem =
    div [ class "container mb-2" ]
        [ div [ class "row justify-content-center" ]
            [ div [ class "col col-md-10 col-lg-8" ]
                [ nav
                , elem
                ]
            ]
        ]


projectNav : Project -> Html Msg
projectNav project =
    div [ class "" ]
        [ h5 [ class "mb-0 ml-header row justify-content-between" ]
            [ div [ class "col font-black" ] [ text " Maisons Léo" ]
            , div [ class "col-auto" ]
                [ i [ class "fa fa-bars cp", onClick (NavigateTo (ProjectRoute project.id)) ] []
                ]
            ]
        ]


genericNav : Html Msg
genericNav =
    h5 [ class "ml-header row justify-content-between" ]
        [ div [ class "col" ] [ text " Maisons Léo" ]
        ]


deactivatedView : Project -> Html Msg
deactivatedView project =
    div []
        [ p [ class "alert alert-warning mt-2" ]
            [ text "L'annonce auquelle correspondait votre projet a été désactivée. Restez à l'affût pour de nouvelles opportunités !"
            ]
        ]
        |> inLayout genericNav


maybeDeactivated : Project -> Html Msg -> Html Msg
maybeDeactivated project view =
    case project.ad.active of
        True ->
            view

        False ->
            deactivatedView project


projectPageView : Model -> Html Msg
projectPageView model =
    case model.project of
        Failure err ->
            failureView err
                |> inLayout genericNav

        NotAsked ->
            notAskedView
                |> inLayout genericNav

        Loading ->
            loadingView
                |> inLayout genericNav

        Success project ->
            projectView model project
                |> inLayout genericNav
                |> maybeDeactivated project


projectHeader : Project -> Html Msg
projectHeader project =
    div [ class "mb-2 mt-2" ]
        [ p [ class "mb-1" ]
            [ span [ class "font-bold" ] [ text "Mon espace" ]
            ]
        , p [ class "mb-0" ]
            [ "Passez toutes les étapes et faites construire votre maison à "
                ++ (AdView.shortAddText project.ad)
                ++ " pour "
                ++ (AdView.totalPrice project.ad)
                |> text
            ]
        ]


projectView : Model -> Project -> Html Msg
projectView model project =
    div []
        [ div [ class "mt-0 mb-5" ]
            [ ul [ class "list-group", style [ ( "margin-right", "-15px" ), ( "margin-left", "-15px" ) ] ]
                (li [ class "list-group-item" ] [ projectHeader project ]
                    :: (List.map (\dStep -> stepIndexView dStep.step model project dStep.label) displaySteps)
                )
            ]
        ]


projectStepPageView : ProjectStep -> Model -> Html Msg
projectStepPageView projectStep model =
    case model.project of
        Failure err ->
            inLayout genericNav (failureView err)

        NotAsked ->
            inLayout genericNav notAskedView

        Loading ->
            inLayout genericNav loadingView

        Success project ->
            let
                stepsWithIndex =
                    List.indexedMap (,) displaySteps
            in
                case List.filter (\( _, dStep ) -> dStep.step == projectStep) stepsWithIndex of
                    ( i, dStep ) :: _ ->
                        dStep.view model project dStep.label (i + 1)
                            |> inLayout (projectNav project)
                            |> maybeDeactivated project

                    _ ->
                        inLayout genericNav (text "Erreur")


type alias DisplayStep =
    { step : ProjectStep
    , view : Model -> Project -> String -> Int -> Html Msg
    , label : String
    }


displaySteps : List DisplayStep
displaySteps =
    [ { step = DiscoverHouse, view = discoverHouseView, label = "Découvrir la maison" }
    , { step = DiscoverLand, view = discoverLandView, label = "Découvrir le terrain" }
    , { step = EvaluateFunding, view = evaluateFundingView, label = "Ma finançabilité" }
    , { step = PhoneCall, view = phoneCallView, label = "Premier contact" }
    , { step = Quotation, view = quotationView, label = "Mon devis" }
    , { step = Funding, view = fundingView, label = "Mon financement" }
    , { step = VisitLand, view = visitLandView, label = "Visite du terrain" }
    , { step = Contract, view = contractView, label = "Signature du contrat" }
    , { step = Permit, view = permitView, label = "Permis de construire" }
    , { step = Building, view = buildingView, label = "Construction" }
    , { step = Keys, view = keysView, label = "Réception" }
    , { step = AfterSales, view = afterSalesView, label = "Service après-vente" }
    ]


checkedIcon : ProjectStepStatus -> Html Msg
checkedIcon state =
    let
        checkedIcon =
            i [ class "fa fa-check fa-lg mr-2 default-color-text" ] []

        currentIcon =
            i [ class "fa fa-hand-o-right fa-lg mr-2 default-color-text" ] []

        notYetIcon =
            i [ class "fa fa-check fa-lg mr-2 text-white" ] []
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
        liAttr =
            case stepState project projectStep of
                Checked ->
                    [ onClick (NavigateTo (ProjectStepRoute project.id projectStep)), class "list-group-item cp gray-hover" ]

                Current ->
                    [ onClick (NavigateTo (ProjectStepRoute project.id projectStep)), class "list-group-item cp font-bold" ]

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
    p [ class "text-secondary text-bold p-1" ] [ text desc ]


nextStepInfo : String -> Html Msg
nextStepInfo txt =
    div [ class "default-color-text pl-1 text-right small mb-0 mt-2" ]
        [ text <| "Étape suivante : " ++ txt ]


stepNum : Int -> Html Msg
stepNum num =
    div [ class "text-secondary small mb-2" ] [ text <| "Étape " ++ (toString num) ++ "/12" ]


stepView : Model -> Project -> String -> Int -> Route -> Html Msg -> Html Msg
stepView model project title num route view =
    div [ class "mt-2" ]
        [ stepNum num
        , h1 [ class "h1-responsive mb-0" ]
            [ a
                [ class "btn btn-sm btn-yellow-flash pr-3 pl-3"
                , onClick (NavigateTo route)
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


customButton : String -> Msg -> Html Msg
customButton label action =
    div [ class "clearfix" ]
        [ button
            [ class "btn btn-default pull-right mr-0 mt-2", onClick action ]
            [ text label ]
        ]


stepButton : Project -> ProjectStep -> Html Msg -> Html Msg
stepButton project step button =
    case stepState project step of
        Checked ->
            button

        Current ->
            button

        NotYet ->
            text ""


landLocation : Land -> String
landLocation land =
    String.join "" [ land.city, " ", "(", land.department, ")" ]


discoverHouseView : Model -> Project -> String -> Int -> Html Msg
discoverHouseView model project title step =
    let
        updateValue =
            Json.Encode.object [ ( "discover_house", Json.Encode.bool True ) ]

        button =
            ValidateDiscoverHouse project.id updateValue |> nextStepButton

        title1 =
            "Le T4 familial par excellence"

        description1 =
            "D'une surface de 80m2, munie de trois chambres et d'un vaste espace commun, la Maison Léo constitue le lieu de vie idéal d'une famille moderne."

        title2 =
            "Un gage de qualité"

        description2 =
            "Robustes et intégralement isolés, les murs de 20cm d'épaisseur de la Maison Léo protègent votre famille du monde extérieur."

        cardSlide =
            \photo title description ->
                Slide.config []
                    (Slide.customContent
                        (div
                            [ class "card m-1 slider-card" ]
                            [ img [ photo |> photoSrc |> src, class "img-fluid" ] []
                            , div [ class "card-body slider-card-body" ]
                                [ p [ class "card-title" ] [ text title ]
                                , p [ class "card-text" ] [ text description ]
                                ]
                            ]
                        )
                    )

        carousel =
            Carousel.config CarouselMsg []
                |> Carousel.withControls
                |> Carousel.withIndicators
                |> Carousel.slides
                    [ cardSlide "maison-min.png" title1 description1
                    , cardSlide "maison_21_nuit.jpg" title2 description2
                    ]
                |> Carousel.view model.discoverHouseCarouselState

        view =
            div []
                [ stepInfo "Découvrez la maison Léo."
                , carousel
                , nextStepInfo "Choisir mes couleurs"
                , stepButton project DiscoverHouse button
                ]
    in
        stepView model project title step (ProjectRoute project.id) view


discoverLandView : Model -> Project -> String -> Int -> Html Msg
discoverLandView model project title step =
    let
        updateValue =
            Json.Encode.object [ ( "discover_land", Json.Encode.bool True ) ]

        button : Html Msg
        button =
            ValidateDiscoverLand project.id updateValue |> nextStepButton

        view =
            div []
                [ stepInfo "Découvrez l'opportunité de terrain que nous vous proposons."
                , div [ class "card mt-2" ]
                    [ div [ id "map", class "img-flex" ] []
                    , div [ class "card-body" ]
                        [ span [ class "pull-right" ] [ project.ad.land.price |> toFloat >> (format { frenchLocale | decimals = 0 }) >> (\p -> p ++ " €") |> text ]
                        , p [ class "card-title" ] [ "Terrain à " ++ (project.ad.land |> landLocation) |> text ]
                        , div [ class "card-text" ] [ text project.ad.land.description ]
                        ]
                    ]
                , nextStepInfo "Découvrir la maison"
                , stepButton project DiscoverLand button
                ]
    in
        stepView model project title step (ProjectStepRoute project.id EvaluateFunding) view


evaluateFundingView : Model -> Project -> String -> Int -> Html Msg
evaluateFundingView model project title step =
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
                [ stepInfo "Pour mener à bien votre projet de construction, nous vous aidons à trouver un financement."
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
                , nextStepInfo "Notre premier contact"
                , stepButton project EvaluateFunding (ValidateEvaluateFunding project.id |> nextStepButton)
                ]
    in
        stepView model project title step (ProjectStepRoute project.id PhoneCall) view


phoneCallView : Model -> Project -> String -> Int -> Html Msg
phoneCallView model project title step =
    let
        phoneNumberValue =
            case model.phoneNumber of
                Just phoneNumber ->
                    phoneNumber

                Nothing ->
                    ""

        nextButton =
            stepButton project PhoneCall (nextStepButton <| NavigateTo <| ProjectStepRoute project.id Quotation)

        alert =
            \phone_number ->
                p [ class "alert alert-info" ]
                    [ text "Merci !"
                    , br [] []
                    , text "Nous allons vous appeler au numéro suivant : "
                    , br [] []
                    , i [ class "fa fa-phone-square mr-1" ] []
                    , span [ class "font-bold" ] [ text phone_number ]
                    ]

        button =
            case ( project.phone_call, project.phone_number, project.phone_number == model.phoneNumber ) of
                ( True, _, _ ) ->
                    nextButton

                ( False, Nothing, _ ) ->
                    customButton "Valider" (SubmitPhoneNumber project.id)

                ( False, Just phone_number, False ) ->
                    div []
                        [ alert phone_number
                        , customButton "Mettre à jour" (SubmitPhoneNumber project.id)
                        ]

                ( False, Just phone_number, True ) ->
                    alert phone_number

        view =
            div []
                [ stepInfo "Nous vous proposons un accompagment personnalisé. Renseignez votre numéro de téléphone et nous vous contacterons dès que possible."
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
                , button
                ]
    in
        stepView model project title step (ProjectStepRoute project.id EvaluateFunding) view


quotationView : Model -> Project -> String -> Int -> Html Msg
quotationView model project title step =
    let
        view =
            div [] []
    in
        stepView model project title step (ProjectStepRoute project.id PhoneCall) view


fundingView : Model -> Project -> String -> Int -> Html Msg
fundingView model project title step =
    let
        view =
            div [] []
    in
        stepView model project title step (ProjectStepRoute project.id Quotation) view


visitLandView : Model -> Project -> String -> Int -> Html Msg
visitLandView model project title step =
    let
        view =
            div [] []
    in
        stepView model project title step (ProjectStepRoute project.id Funding) view


contractView : Model -> Project -> String -> Int -> Html Msg
contractView model project title step =
    let
        view =
            div [] []
    in
        stepView model project title step (ProjectStepRoute project.id VisitLand) view


permitView : Model -> Project -> String -> Int -> Html Msg
permitView model project title step =
    let
        view =
            div [] []
    in
        stepView model project title step (ProjectStepRoute project.id Contract) view


buildingView : Model -> Project -> String -> Int -> Html Msg
buildingView model project title step =
    let
        view =
            div [] []
    in
        stepView model project title step (ProjectStepRoute project.id Permit) view


keysView : Model -> Project -> String -> Int -> Html Msg
keysView model project title step =
    let
        view =
            div [] []
    in
        stepView model project title step (ProjectStepRoute project.id Building) view


afterSalesView : Model -> Project -> String -> Int -> Html Msg
afterSalesView model project title step =
    let
        view =
            div [] []
    in
        stepView model project title step (ProjectStepRoute project.id Keys) view
