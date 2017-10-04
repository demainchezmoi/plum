module Project.View exposing (..)

import Ad.Model exposing (Ad)
import Ad.View as AdView
import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Messages exposing (..)
import Model exposing (..)
import Project.Model exposing (..)
import Routing exposing (toPath, Route(..))
import ViewHelpers exposing (..)
import RemoteData exposing (..)
import Json.Encode


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


projectView : Model -> Project -> Html Msg
projectView model project =
    div []
        [ adHeader project.ad
        , photo "maison_21.png"
        , div [ class ("mt-3 mb-5 " ++ (slidingClass model.projectAnimation)) ]
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
    [ { step = DiscoverLand, view = discoverLandView, label = "Découvrir le lieu" }
    , { step = DiscoverHouse, view = discoverHouseView, label = "Découvrir la maison" }
    , { step = ConfigureHouse, view = configureHouseView, label = "Ma configuration" }
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


photo : String -> Html Msg
photo string =
    img
        [ class "d-block p-2 img-thumbnail mt-3 img-fluid"
        , src ("https://s3-eu-west-1.amazonaws.com/demainchezmoi/cloudfront_assets/images/" ++ string)
        ]
        []


adHeader : Ad -> Html Msg
adHeader ad =
    div [ class "mt-3 p-3 light-bordered text-center" ]
        [ h4 [ class "font-black h4-responsive" ] [ text "Mon espace" ]
        , p [ class "lead mb-0" ] [ AdView.shortView ad ]
        ]


stepState : Project -> ProjectStep -> ProjectStepState
stepState project projectStep =
    let
        indexedSteps =
            List.indexedMap (,) project.steps

        stepIndex =
            case List.filter (\( i, s ) -> s.step == projectStep) indexedSteps of
                ( i, s ) :: _ ->
                    i

                _ ->
                    10100

        ( valid, invalid ) =
            List.partition (\( i, s ) -> s.valid == True) indexedSteps

        firstInvalidIndex =
            case invalid of
                ( i, s ) :: _ ->
                    i

                _ ->
                    10000
    in
        if stepIndex == firstInvalidIndex then
            Current
        else if stepIndex > firstInvalidIndex then
            NotYet
        else
            Checked


slidingClass : SlideAnimation -> String
slidingClass status =
    case status of
        EnterRight ->
            "enterRight"

        EnterLeft ->
            "enterLeft"

        None ->
            ""


checkedIcon : ProjectStepState -> Html Msg
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
    li [ "list-group-item cp gray-hover" |> class, onClick (ProjectToStep (ProjectStepRoute project.id projectStep)) ]
        [ a []
            [ checkedIcon (stepState project projectStep)
            , label |> text
            ]
        ]


stepView : Model -> Project -> String -> Html Msg -> Html Msg
stepView model project title view =
    let
        stepClass =
            String.join " " [ slidingClass model.projectStepAnimation ]
    in
        div []
            [ div [ class stepClass ]
                [ h1 [ class "h1-responsive" ]
                    [ a
                        [ class "btn btn-sm btn-yellow-flash"
                        , onClick (StepToProject (ProjectRoute project.id))
                        ]
                        [ i [ class "fa fa-chevron-left" ] []
                        ]
                    , text title
                    ]
                , view
                ]
            ]


nextStepButton : Msg -> Html Msg
nextStepButton action =
    button
        [ class "btn btn-default", onClick action ]
        [ text "Étape suivante" ]


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
            div [] [ button ]
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
                [ photo "maison_21_nuit.jpg"
                , photo "maison-min.png"
                , button
                ]
    in
        stepView model project title view


configureHouseView : Model -> Project -> String -> Html Msg
configureHouseView model project title =
    let
        view =
            div [] []
    in
        stepView model project title view


evaluateFundingView : Model -> Project -> String -> Html Msg
evaluateFundingView model project title =
    let
        view =
            div [] []
    in
        stepView model project title view


phoneCallView : Model -> Project -> String -> Html Msg
phoneCallView model project title =
    let
        view =
            div [] []
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
