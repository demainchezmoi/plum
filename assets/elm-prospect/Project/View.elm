module Project.View exposing (..)

import Ad.Model exposing (Ad)
import Ad.View as AdView
import Html exposing (..)
import Html.Attributes exposing (class, src, type_, name, value, id, checked, for, placeholder, style)
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


projectNav : ProjectId -> Html Msg
projectNav projectId =
    div [ class "" ]
        [ h5 [ class "mb-0 ml-header row justify-content-between" ]
            [ div [ class "col font-black" ]
                [ i [ class "fa fa-home" ] []
                , text " Maisons Léo"
                ]
            , div [ class "col-auto" ]
                [ i [ class "fa fa-bars cp", onClick (NavigateTo (ProjectRoute projectId)) ] []
                ]
            ]
        ]


genericNav : Html Msg
genericNav =
    h5 [ class "ml-header row justify-content-between" ]
        [ div [ class "col" ]
            [ i [ class "fa fa-home" ] []
            , text " Maisons Léo"
            ]
        , div [ class "col-auto" ] []
        ]


projectPageView : Model -> Html Msg
projectPageView model =
    case model.project of
        Failure err ->
            inLayout genericNav (failureView err)

        NotAsked ->
            inLayout genericNav notAskedView

        Loading ->
            inLayout genericNav loadingView

        Success project ->
            inLayout (projectNav project.id) (projectView model project)


projectHeader : Project -> Html Msg
projectHeader project =
    div [ class "media pt-3 pb-3" ]
        [ img [ class "d-flex mr-2 img-thumbnail", src "https://s3-eu-west-1.amazonaws.com/demainchezmoi/cloudfront_assets/images/maison_21.png", style [ ( "width", "100px" ), ( "height", "56.25px" ) ] ] []
        , div [ class "media-body" ]
            [ p [ class "mt-0 mb-0" ]
                [ span [ class "font-bold" ] [ text "Mon espace" ]
                ]
            , AdView.shortView project.ad
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
            case List.filter (\dStep -> dStep.step == projectStep) displaySteps of
                dStep :: _ ->
                    inLayout (projectNav project.id) (dStep.view model project dStep.label)

                _ ->
                    inLayout genericNav (text "Erreur")


type alias DisplayStep =
    { step : ProjectStep
    , view : Model -> Project -> String -> Html Msg
    , label : String
    }


displaySteps : List DisplayStep
displaySteps =
    [ { step = Welcome, view = welcomeView, label = "Bienvenue dans votre espace" }
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
    div [ class "text-secondary small mb-2" ] [ text <| "Étape " ++ (toString num) ++ "/14" ]


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


welcomeView : Model -> Project -> String -> Html Msg
welcomeView model project title =
    let
        text1 =
            "Bienvenue dans votre espace Maisons Léo."

        text2 =
            "Cet espace vous permet de gérer votre candidature pour l'annonce maison plus terrain à " ++ (landLocation project.ad.land) ++ "."

        text3 =
            "Nous vous accompagnons tout au long du processus de construction de maison."

        text4 =
            "Passez les étapes pour découvrir le terrain, la maison, choisir vos couleurs, jusqu'au suivi de la construction et l'obtention de vos clés."

        button =
            (NavigateTo (ProjectStepRoute project.id DiscoverLand)) |> nextStepButton

        view =
            div []
                [ stepInfo text1
                , div [ class "card mt-2" ]
                    [ div [ class "card-body" ]
                        [ p [ class "card-title" ]
                            [ i [ class "fa fa-home mr-2" ] []
                            , text "Gérez tout votre projet de construction en un seul endroit."
                            ]
                        , div [ class "card-text" ] [ text text2 ]
                        ]
                    , hr [ class "mt-1 mb-1" ] []
                    , div [ class "card-body" ]
                        [ p [ class "card-title" ]
                            [ i [ class "fa fa-handshake-o mr-2" ] []
                            , text "Recevez un accompagnement personalisé."
                            ]
                        , div [ class "card-text" ] [ text text3 ]
                        ]
                    , hr [ class "mt-1 mb-1" ] []
                    , div [ class "card-body" ]
                        [ p [ class "card-title" ]
                            [ i [ class "fa fa-rocket mr-2" ] []
                            , text "Passez les étapes une à une jusqu'à la réception vos clés."
                            ]
                        , div [ class "card-text" ] [ text text4 ]
                        ]
                    ]
                , nextStepInfo "Découvrir le terrain"
                , button
                ]
    in
        stepView model project title 1 (ProjectRoute project.id) view


landLocation : Land -> String
landLocation land =
    String.join "" [ land.city, " ", "(", land.department, ")" ]


discoverLandView : Model -> Project -> String -> Html Msg
discoverLandView model project title =
    let
        updateValue =
            Json.Encode.object [ ( "discover_land", Json.Encode.bool True ) ]

        button : Html Msg
        button =
            ValidateDiscoverLand project.id updateValue |> nextStepButton

        view =
            div []
                [ stepInfo "Découvrez le terrain sur lequel nous vous proposons de construire une Maison Léo."
                , div [ class "card mt-2" ]
                    [ div [ id "map", style [ ( "height", "200px" ) ], class "img-flex" ] []
                    , div [ class "card-body" ]
                        [ p [ class "card-title" ] [ "Terrain à " ++ (project.ad.land |> landLocation) |> text ]
                        , div [ class "card-text" ] [ text project.ad.land.description ]
                        ]
                    ]
                , nextStepInfo "Découvrir la maison"
                , stepButton project DiscoverLand button
                ]
    in
        stepView model project title 2 (ProjectStepRoute project.id Welcome) view


discoverHouseView : Model -> Project -> String -> Html Msg
discoverHouseView model project title =
    let
        updateValue =
            Json.Encode.object [ ( "discover_house", Json.Encode.bool True ) ]

        button =
            ValidateDiscoverHouse project.id updateValue |> nextStepButton

        description1 =
            "D'une surface de 80m2, munie de trois chambres et d'un vaste espace commun, la Maison Léo constitue le lieu de vie idéal d'une famille moderne."

        description2 =
            "Robustes et intégralement isolés, les murs de 20cm d'épaisseur de la Maison Léo protègent votre famille du monde extérieur."

        view =
            div []
                [ stepInfo "Découvrez la maison Léo."
                , div [ class "card mt-2" ]
                    [ cardPhoto "maison-min.png"
                    , div [ class "card-body" ]
                        [ p [ class "card-title" ] [ text "Le T4 familial par excellence." ]
                        , div [ class "card-text" ] [ text description1 ]
                        ]
                    ]
                , div [ class "card mt-2" ]
                    [ cardPhoto "maison_21_nuit.jpg"
                    , div [ class "card-body" ]
                        [ p [ class "card-title" ] [ text "Un gage de qualité." ]
                        , div [ class "card-text" ] [ text description2 ]
                        ]
                    ]
                , nextStepInfo "Choisir mes couleurs"
                , stepButton project DiscoverHouse button
                ]
    in
        stepView model project title 3 (ProjectStepRoute project.id DiscoverLand) view


configureHouseView : Model -> Project -> String -> Html Msg
configureHouseView model project title =
    let
        photo0 =
            img [ src (photoSrc "Maison-leo-configurateur-0.png"), class "img-fluid" ] []

        color1 =
            "Maison-leo-configurateur-1.png"

        color2 =
            "Maison-leo-configurateur-2.png"

        ( photo1, checked11, checked12 ) =
            case ( model.houseColor1, project.house_color_1 ) of
                ( Just house_color_1, _ ) ->
                    ( img [ class "photo-stack img-fluid", src <| photoSrc <| house_color_1 ] [], house_color_1 == color1, house_color_1 == color2 )

                ( Nothing, Just house_color_1 ) ->
                    ( img [ class "photo-stack img-fluid", src <| photoSrc <| house_color_1 ] [], house_color_1 == color1, house_color_1 == color2 )

                _ ->
                    ( span [] [], False, False )

        ( photo2, checked21, checked22 ) =
            case ( model.houseColor2, project.house_color_2 ) of
                ( Just house_color_2, _ ) ->
                    ( img [ class "photo-stack img-fluid", src <| photoSrc <| house_color_2 ] [], house_color_2 == color1, house_color_2 == color2 )

                ( Nothing, Just house_color_2 ) ->
                    ( img [ class "photo-stack img-fluid", src <| photoSrc <| house_color_2 ] [], house_color_2 == color1, house_color_2 == color2 )

                _ ->
                    ( span [] [], False, False )

        view =
            div []
                [ stepInfo "Faites-vous plaisir : choisissez les enduits de votre maison Léo, en une ou deux couleurs."
                , div [ class "card mt-2" ]
                    [ div [ class "position-relative" ] [ photo0, photo1, photo2 ]
                    , div [ class "card-body" ]
                        [ p [ class "card-title" ] [ text "Choisissez vos couleurs." ]
                        , div [ class "row card-text" ]
                            [ div [ class "col-6" ]
                                [ p [ class "font-bold" ] [ text "Couleur 2" ]
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
                                [ p [ class "font-bold" ] [ text "Couleur 1" ]
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
                    ]
                , nextStepInfo "Ma finançabilité"
                , stepButton project ConfigureHouse (ValidateConfigureHouse project.id |> nextStepButton)
                ]
    in
        stepView model project title 4 (ProjectStepRoute project.id DiscoverHouse) view


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
        stepView model project title 5 (ProjectStepRoute project.id ConfigureHouse) view


phoneCallView : Model -> Project -> String -> Html Msg
phoneCallView model project title =
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
                    [ text "Nous allons vous appeler au numéro suivant : "
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
        stepView model project title 6 (ProjectStepRoute project.id EvaluateFunding) view


quotationView : Model -> Project -> String -> Html Msg
quotationView model project title =
    let
        view =
            div [] []
    in
        stepView model project title 7 (ProjectStepRoute project.id PhoneCall) view


fundingView : Model -> Project -> String -> Html Msg
fundingView model project title =
    let
        view =
            div [] []
    in
        stepView model project title 8 (ProjectStepRoute project.id Quotation) view


visitLandView : Model -> Project -> String -> Html Msg
visitLandView model project title =
    let
        view =
            div [] []
    in
        stepView model project title 9 (ProjectStepRoute project.id Funding) view


contractView : Model -> Project -> String -> Html Msg
contractView model project title =
    let
        view =
            div [] []
    in
        stepView model project title 10 (ProjectStepRoute project.id VisitLand) view


permitView : Model -> Project -> String -> Html Msg
permitView model project title =
    let
        view =
            div [] []
    in
        stepView model project title 11 (ProjectStepRoute project.id Contract) view


buildingView : Model -> Project -> String -> Html Msg
buildingView model project title =
    let
        view =
            div [] []
    in
        stepView model project title 12 (ProjectStepRoute project.id Permit) view


keysView : Model -> Project -> String -> Html Msg
keysView model project title =
    let
        view =
            div [] []
    in
        stepView model project title 13 (ProjectStepRoute project.id Building) view


afterSalesView : Model -> Project -> String -> Html Msg
afterSalesView model project title =
    let
        view =
            div [] []
    in
        stepView model project title 14 (ProjectStepRoute project.id Keys) view
