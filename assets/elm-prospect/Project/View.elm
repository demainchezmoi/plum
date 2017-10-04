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
import ViewHelpers exposing (remoteDataView, inLayout)
import RemoteData exposing (..)


projectPageView : Model -> Html Msg
projectPageView model =
    remoteDataView model model.project projectView


type alias DisplayStep =
    { step : ProjectStep
    , view : Model -> ProjectId -> String -> Html Msg
    , label : String
    }


displaySteps : List DisplayStep
displaySteps =
    [ { step = DiscoverLand, view = discoverLandView, label = "Découvrir le terrain" }
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


projectStepPageView : ProjectStep -> ProjectId -> Model -> Html Msg
projectStepPageView projectStep projectId model =
    case (List.filter (\dStep -> dStep.step == projectStep) displaySteps) |> List.head of
        Just dStep ->
            dStep.view model projectId dStep.label

        Nothing ->
            text "Not Found"


header : Html Msg
header =
    h5 [ class "ml-header" ]
        [ i [ class "fa fa-home" ] []
        , text " Maisons Léo"
        ]


photo : Html Msg
photo =
    img
        [ class "d-block p-2 img-thumbnail mt-3 img-fluid"
        , src "https://s3-eu-west-1.amazonaws.com/demainchezmoi/cloudfront_assets/images/maison_21.png"
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
            case (List.filter (\( i, s ) -> s.step == projectStep) indexedSteps) |> List.head of
                Just ( i, s ) ->
                    i

                Nothing ->
                    10100

        ( checked, unchecked ) =
            List.partition (\( i, s ) -> s.checked == True) indexedSteps

        firstUncheckedIndex =
            case List.head unchecked of
                Just ( i, s ) ->
                    i

                Nothing ->
                    10000
    in
        if stepIndex == firstUncheckedIndex then
            Current
        else if stepIndex > firstUncheckedIndex then
            NotYet
        else
            Checked


projectView : Model -> Project -> Html Msg
projectView model project =
    div []
        [ header
        , adHeader project.ad
        , photo
        , div [ class ("mt-3 mb-5 " ++ (slidingClass model.projectAnimation)) ]
            [ ul [ class "list-group" ]
                (List.map (\dStep -> stepIndexView dStep.step model project dStep.label) displaySteps)
            ]
        ]
        |> inLayout


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
checkedIcon checked =
    let
        checkedIcon =
            span [ class "fa-stack mr-2" ]
                [ i [ class "fa fa-circle fa-stack-2x yellow-flash-text black-bordered-icon" ] []
                , i [ class "fa fa-check fa-stack-1x" ] []
                ]

        currentIcon =
            span [ class "fa-stack mr-2" ]
                [ i [ class "fa fa-circle fa-stack-2x" ] []
                , i [ class "fa fa-question fa-stack-1x fa-inverse" ] []
                ]

        notYetIcon =
            span [ class "fa-stack mr-2 text-secondary" ]
                [ i [ class "fa fa-circle fa-stack-2x" ] []
                , i [ class "fa fa-question fa-stack-1x fa-inverse" ] []
                ]
    in
        case checked of
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


stepView : Model -> ProjectId -> String -> Html Msg -> Html Msg
stepView model projectId title view =
    let
        stepClass =
            String.join " " [ slidingClass model.projectStepAnimation ]
    in
        div []
            [ header
            , div [ class stepClass ]
                [ h1 [ class "h1-responsive" ]
                    [ a
                        [ class "btn btn-sm btn-yellow-flash"
                        , onClick (StepToProject (ProjectRoute projectId))
                        ]
                        [ i [ class "fa fa-chevron-left" ] []
                        ]
                    , text title
                    ]
                , view
                ]
            ]
            |> inLayout


nextStepButton : Msg -> Html Msg
nextStepButton action =
    button
        [ class "btn btn-default", onClick action ]
        [ text "Étape suivante" ]


discoverLandView : Model -> ProjectId -> String -> Html Msg
discoverLandView model projectId title =
    let
        view =
            case model.project of
                Success project ->
                    div [] [ UpdateProject project |> nextStepButton ]

                _ ->
                    div [] []
    in
        stepView model projectId title view


discoverHouseView : Model -> ProjectId -> String -> Html Msg
discoverHouseView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view


configureHouseView : Model -> ProjectId -> String -> Html Msg
configureHouseView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view


evaluateFundingView : Model -> ProjectId -> String -> Html Msg
evaluateFundingView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view


phoneCallView : Model -> ProjectId -> String -> Html Msg
phoneCallView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view


quotationView : Model -> ProjectId -> String -> Html Msg
quotationView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view


fundingView : Model -> ProjectId -> String -> Html Msg
fundingView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view


visitLandView : Model -> ProjectId -> String -> Html Msg
visitLandView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view


contractView : Model -> ProjectId -> String -> Html Msg
contractView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view


permitView : Model -> ProjectId -> String -> Html Msg
permitView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view


buildingView : Model -> ProjectId -> String -> Html Msg
buildingView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view


keysView : Model -> ProjectId -> String -> Html Msg
keysView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view


afterSalesView : Model -> ProjectId -> String -> Html Msg
afterSalesView model projectId title =
    let
        view =
            div [] []
    in
        stepView model projectId title view
