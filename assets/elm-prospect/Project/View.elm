module Project.View exposing (..)

import Ad.Model as AdModel exposing (Ad)
import Ad.View as AdView
import Bootstrap.Card as Card
import Bootstrap.Carousel as Carousel
import Bootstrap.Carousel.Slide as Slide
import Bootstrap.Modal as Modal
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
    div [ class "container", style [ ( "margin-bottom", "70px" ) ] ]
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
            [ div [ class "col" ] [ text " Maisons Léo" ]
            , div [ class "col-auto" ]
                [ i [ class "fa fa-bars cp", onClick (NavigateTo (ProjectRoute project.id)) ] []
                ]
            ]
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
    , { step = PhoneCall, view = phoneCallView, label = "Prenons contact" }
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
    case txt of
        "" ->
            div [] []

        _ ->
            div [ class "default-color-text pr-1 text-right small mr-1", style [ ( "line-height", "15px" ) ] ]
                [ text <| "Étape suivante"
                , br [] []
                , text txt
                ]


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
    customButton "Suivant" "" action


customButton : String -> String -> Msg -> Html Msg
customButton label cClass action =
    button
        [ class ("btn btn-default m-0 pr-3 pl-3 " ++ cClass), onClick action ]
        [ text label ]


nextStepFooter : String -> Html Msg -> Html Msg
nextStepFooter bText button =
    div [ class "next-step-footer" ]
        [ div [ class "container" ]
            [ div [ class "row justify-content-center" ]
                [ div [ class "col col-md-10 col-lg-8" ]
                    [ div [ class "next-step-footer-content" ]
                        [ nextStepInfo bText
                        , button
                        ]
                    ]
                ]
            ]
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


colorRadio : String -> String -> Bool -> (String -> Msg) -> String -> Html Msg
colorRadio inputName inputValue inputChecked action inputLabel =
    div [ class "form-check" ]
        [ label [ class "form-check-label" ]
            [ input
                [ type_ "radio"
                , name inputName
                , value inputValue
                , id (inputName ++ "_" ++ inputValue)
                , class "form-check-input"
                , checked inputChecked
                , onClick (action inputValue)
                ]
                []
            , text inputLabel
            ]
        ]


cardSlide : String -> String -> Html Msg -> Slide.Config Msg
cardSlide photo title body =
    Slide.config []
        (Slide.customContent
            (div [ class "card slider-card" ]
                [ img [ photo |> src, class "img-fluid" ] []
                , div [ class "card-body" ]
                    [ p [ class "card-title" ] [ text title ]
                    , p [ class "card-text" ] [ body ]
                    ]
                ]
            )
        )


discoverHouseView : Model -> Project -> String -> Int -> Html Msg
discoverHouseView model project title step =
    let
        updateValue =
            Json.Encode.object [ ( "discover_house", Json.Encode.bool True ) ]

        button =
            ValidateDiscoverHouse project.id updateValue |> nextStepButton

        title1 =
            "87 m2 pour familles heureuses"

        description1 =
            div []
                [ ul [ class "list-unstyled" ]
                    [ li [] [ text "Isolées par des cloisons épaisses, les trois chambres garantissent à chacun un espace au calme." ]
                    , li [] [ text "Le séjour cuisine de 48m2 vous permet de partager repas et bons films tous ensemble et les deux grandes baies vitrées vous invitent profiter du soleil, de l'air frais et du jardin." ]
                    , li [] []
                    , li [] [ text "Laissez-vous tenter par des après-midis balançoire, football, cabane et soirées plancha dans le jardin !" ]
                    ]
                ]

        title2 =
            "La maison LÉO, une maison de qualité !"

        description2 =
            div []
                [ text "Nous fabriquons la maison Léo d'après des plans uniques et optimisés pour garantir une prestation hors pair au meilleur prix."
                , br [] []
                , text "La maison Léo est fabriquée près de chez vous, à l'aide de matériaux robustes et de solutions techniques éprouvées."
                , br [] []
                , br [] []
                , text "Garantie 0% gadget, la maison Léo offre tout le confort moderne: isolation par l'extérieur, prises internet dans chaque pièce, 5m2 de panneaux solaires, ventilation simple flux."
                ]

        colors =
            [ ( "1", "house_colors/Maison-leo-uni-withe.png", "Blanc" )
            , ( "2", "house_colors/Maison-leo-uni-withe-new-york.png", "Blanc / New York" )
            , ( "3", "house_colors/Maison-leo-uni-newyork.png", "New York" )
            ]

        colorsSlide =
            Slide.config []
                (Slide.customContent
                    (div [ class "card slider-card" ]
                        [ img [ model.houseColor |> photoSrc |> src, class "img-fluid" ] []
                        , div [ class "card-body" ]
                            [ p [ class "card-title" ] [ text "Faites la changer de couleur !" ]
                            , p [ class "card-text" ]
                                (colors
                                    |> List.map
                                        (\( name, val, label ) ->
                                            colorRadio
                                                name
                                                val
                                                (model.houseColor == val)
                                                SetHouseColor
                                                label
                                        )
                                )
                            ]
                        ]
                    )
                )

        carousel =
            Carousel.config CarouselHouseMsg []
                |> Carousel.withControls
                |> Carousel.withIndicators
                |> Carousel.slides
                    [ cardSlide (photoSrc "distribution_commercial_maison_leo_sd.png") title1 description1
                    , cardSlide (photoSrc "maison_21_nuit.jpg") title2 description2
                    , colorsSlide
                    ]
                |> Carousel.view model.discoverHouseCarouselState

        view =
            div []
                [ stepInfo "Découvrez la maison Léo."
                , carousel
                , nextStepFooter "Découvrir le terrain" (stepButton project DiscoverHouse button)
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

        landPhoto =
            case project.ad.land.images of
                photo :: _ ->
                    photo

                _ ->
                    photoSrc "grass.png"

        landPrice =
            project.ad.land.price
                |> toFloat
                >> (format { frenchLocale | decimals = 0 })
                >> (\p -> p ++ " €")

        description =
            project.ad.land.description

        landTitle =
            "Le terrain - " ++ landPrice

        landSlide =
            [ cardSlide landPhoto landTitle (text description) ]

        mapSlide =
            case project.ad.land.location of
                Nothing ->
                    []

                Just _ ->
                    [ Slide.config []
                        (Slide.customContent
                            (div
                                [ class "card slider-card" ]
                                [ div [ id "map", class "img-flex" ] []
                                , div [ class "card-body" ]
                                    [ p [ class "card-title" ] [ text "L'emplacement" ]
                                    , p [ class "card-text" ] [ text "Visualisez la zone dans laquelle se trouve votre terrain." ]
                                    ]
                                ]
                            )
                        )
                    ]

        carousel =
            Carousel.config CarouselLandMsg []
                |> Carousel.withControls
                |> Carousel.withIndicators
                |> Carousel.slides (mapSlide ++ landSlide)
                |> Carousel.view model.discoverLandCarouselState

        view =
            div []
                [ stepInfo "Découvrez l'opportunité de terrain que nous vous proposons."
                , carousel
                , nextStepFooter "Découvrir la Maison Léo" (stepButton project DiscoverLand button)
                ]
    in
        stepView model project title step (ProjectStepRoute project.id DiscoverHouse) view



-- Evaluate Funding


isFundable : Project -> Maybe Bool
isFundable project =
    case ( project.net_income, project.contribution ) of
        ( Just net_income, Just contribution ) ->
            Just (contribution >= project.ad.land.notary_fees && net_income >= 1500)

        _ ->
            Nothing


projectFundingValuesAreSet : Project -> Bool
projectFundingValuesAreSet project =
    case ( project.net_income, project.contribution ) of
        ( Just _, Just _ ) ->
            True

        _ ->
            False


modelFundingValuesAreSet : Model -> Bool
modelFundingValuesAreSet model =
    case ( model.netIncome, model.contribution ) of
        ( Just _, Just _ ) ->
            True

        _ ->
            False


contributionValue : Model -> String
contributionValue model =
    case model.contribution of
        Just contribution ->
            toString contribution

        Nothing ->
            ""


netIncomeValue : Model -> String
netIncomeValue model =
    case model.netIncome of
        Just netIncome ->
            toString netIncome

        Nothing ->
            ""


fundableView : Html Msg
fundableView =
    div [ class "p-3 light-bordered" ]
        [ p [ class "default-color-text font-bold" ] [ text "Félicitations, votre projet semble être finançable !" ]
        , text "Passez à l'étape suivante et renseignez votre numéro de téléphone pour que nous puissions entrer en contact."
        ]


notFundableView : Html Msg
notFundableView =
    div [ class "alert alert-warning" ]
        [ p [] [ text "Désolé, votre projet ne semble malheureusement pas finançable." ]
        , text "Restez vigilants et revenez postuler si une offre Maison Léo moins chère apparaît !"
        ]


fundableInfosView : Project -> Html Msg
fundableInfosView project =
    case isFundable project of
        Nothing ->
            div [] []

        Just True ->
            fundableView

        Just False ->
            notFundableView


evaluateFundingView : Model -> Project -> String -> Int -> Html Msg
evaluateFundingView model project title step =
    let
        ( modalButtonClass, modalButtonAttr ) =
            case ( model.evaluateFundingConfirm1, model.evaluateFundingConfirm2 ) of
                ( True, True ) ->
                    ( "", [ onClick (ValidateEvaluateFunding project.id) ] )

                _ ->
                    ( "disabled", [] )

        formView =
            div []
                [ div [ class "alert alert-warning" ]
                    [ text "Attention : vous ne pourrez plus changer les montants déclarés par la suite. Renseignez des informations exactes."
                    , br [] []
                    ]
                , div [ class "form-group" ]
                    [ label [ for "contribution" ] [ text "Votre apport financier (€)" ]
                    , input
                        [ type_ "number"
                        , class "form-control"
                        , id "contribution"
                        , placeholder "ex : 7000"
                        , onInput SetContribution
                        , value <| contributionValue model
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
                        , value <| netIncomeValue model
                        ]
                        []
                    ]
                ]

        decalredValuesView =
            div [ class "p-3 light-bordered mb-2" ]
                [ dl [ class "row mb-1" ]
                    [ dt [ class "col" ] [ text "Apport financier" ]
                    , dd [ class "col-auto pl-0 mb-0" ] [ text (contributionValue model ++ " €") ]
                    ]
                , dl [ class "row mb-0" ]
                    [ dt [ class "col" ] [ text "Revenu mensuel net" ]
                    , dd [ class "col-auto pl-0 mb-0" ] [ text (netIncomeValue model ++ " €") ]
                    ]
                ]

        setValuesView =
            div []
                [ decalredValuesView
                , fundableInfosView project
                ]

        mainView =
            case projectFundingValuesAreSet project of
                True ->
                    setValuesView

                False ->
                    formView

        modalView =
            Modal.config EvaluateFundingModalMsg
                |> Modal.small
                |> Modal.h3 [] [ text "Confirmation" ]
                |> Modal.body []
                    [ decalredValuesView
                    , div [ class "form-check p-3 light-bordered" ]
                        [ label [ class "form-check-label" ]
                            [ input
                                [ type_ "checkbox"
                                , class "form-check-input"
                                , onClick ToggleEvaluateFundingConfirm1
                                , checked model.evaluateFundingConfirm1
                                ]
                                []
                            , text "Je confirme l'exactitude des informations renseignées."
                            ]
                        , br [] []
                        , br [] []
                        , label [ class "form-check-label" ]
                            [ input
                                [ type_ "checkbox"
                                , class "form-check-input"
                                , onClick ToggleEvaluateFundingConfirm2
                                , checked model.evaluateFundingConfirm2
                                ]
                                []
                            , text "Je comprends que je ne pourrai plus changer ces informations par la suite et que des informations erronées compromettraient les chances de réussite de mon projet."
                            ]
                        ]
                    , button ([ class ("btn btn-danger " ++ modalButtonClass) ] ++ modalButtonAttr) [ text "confirmer" ]
                    ]
                |> Modal.view model.evaluateFundingModal

        footerView =
            case isFundable project of
                Just True ->
                    nextStepFooter "Prenons contact"
                        (stepButton
                            project
                            EvaluateFunding
                            (nextStepButton (NavigateTo (ProjectStepRoute project.id PhoneCall)))
                        )

                Just False ->
                    div [] []

                Nothing ->
                    if model |> modelFundingValuesAreSet then
                        nextStepFooter "" (customButton "Valider" "" (EvaluateFundingModalMsg Modal.visibleState))
                    else
                        nextStepFooter "" (customButton "Valider" "disabled" NoOp)

        view =
            div []
                [ stepInfo "Pour mener à bien votre projet de construction, nous vous aidons à trouver un financement."
                , div [ class "p-1" ] [ mainView ]
                , footerView
                , modalView
                ]
    in
        stepView model project title step (ProjectStepRoute project.id DiscoverLand) view



-- PhoneCall


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

        docs =
            p [ class "p-3 alert alert-info" ]
                [ p [ class "text-underline" ] [ text "Afin de préparer votre dossier de financement, préparez les documents suivants :" ]
                , ul [ class "mb-0", style [ ( "padding-left", "20px" ) ] ]
                    [ li [ class "" ] [ text "Vos trois derniers bulletins de salaire" ]
                    , li [ class "" ] [ text "Votre bulletin de salaire de décembre" ]
                    , li [ class "" ] [ text "Votre dernier avis d'imposition" ]
                    , li [ class "" ] [ text "Les trois derniers relevés de chacun de vos comptes en banque" ]
                    , li [ class "" ] [ text "Vos encours de crédits" ]
                    , li [ class "" ] [ text "Une photocopie de votre CNI ou passeport" ]
                    ]
                ]

        sumUp =
            \phone_number ->
                p [ class "mt-2 p-3 light-bordered" ]
                    [ p [] [ text "Nous allons vous appeler à ce numéro pour faire le point sur votre projet et votre financement :" ]
                    , div [ class "row align-items-center" ]
                        [ span [ class "col font-bold" ] [ text phone_number ]
                        , a [ onClick ChangePhone, class "text-info col-auto" ] [ text "modifier" ]
                        ]
                    ]

        setPhoneView =
            \button ->
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
                    , nextStepFooter "" button
                    ]

        phoneSetView =
            \phone_number ->
                div []
                    [ sumUp phone_number
                    , docs
                    ]

        view =
            case ( project.phone_call, project.phone_number, model.changePhone ) of
                ( True, Just phone_number, _ ) ->
                    phoneSetView phone_number

                ( True, Nothing, _ ) ->
                    setPhoneView (customButton "Valider" "" (SubmitPhoneNumber project.id))

                ( _, Nothing, _ ) ->
                    setPhoneView (customButton "Valider" "" (SubmitPhoneNumber project.id))

                ( _, Just phone_number, True ) ->
                    setPhoneView (customButton "Mettre à jour" "" (SubmitPhoneNumber project.id))

                ( _, Just phone_number, False ) ->
                    phoneSetView phone_number
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
