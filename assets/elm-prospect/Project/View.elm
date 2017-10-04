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


projectPageView : Model -> Html Msg
projectPageView model =
    remoteDataView model model.project projectView


projectStepPageView : ProjectStep -> ProjectId -> Model -> Html Msg
projectStepPageView projectStep projectId model =
    case projectStep of
        DiscoverLand ->
            discoverLandView model projectId (stepTitle DiscoverLand)

        DiscoverHouse ->
            discoverHouseView model projectId (stepTitle DiscoverHouse)

        ConfigureHouse ->
            configureHouseView model projectId (stepTitle ConfigureHouse)

        EvaluateFunding ->
            evaluateFundingView model projectId (stepTitle EvaluateFunding)

        PhoneCall ->
            phoneCallView model projectId (stepTitle PhoneCall)

        Quotation ->
            quotationView model projectId (stepTitle Quotation)

        Funding ->
            fundingView model projectId (stepTitle Funding)

        VisitLand ->
            visitLandView model projectId (stepTitle VisitLand)

        Contract ->
            contractView model projectId (stepTitle Contract)

        BuildingPermit ->
            buildingPermitView model projectId (stepTitle BuildingPermit)

        Building ->
            buildingView model projectId (stepTitle Building)

        Keys ->
            keysView model projectId (stepTitle Keys)

        AfterSales ->
            afterSalesView model projectId (stepTitle AfterSales)


stepTitle : ProjectStep -> String
stepTitle projectStep =
    case projectStep of
        DiscoverLand ->
            "Découvrir le terrain"

        DiscoverHouse ->
            "Découvrir la maison"

        ConfigureHouse ->
            "Ma configuration"

        EvaluateFunding ->
            "Ma finançabilité"

        PhoneCall ->
            "Premier contact"

        Quotation ->
            "Mon devis"

        Funding ->
            "Mon financement"

        VisitLand ->
            "Visite du terrain"

        Contract ->
            "Signature du contrat"

        BuildingPermit ->
            "Permis de construire"

        Building ->
            "Construction"

        Keys ->
            "Récéption"

        AfterSales ->
            "Service après-vente"


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
    div [ class "mt-3 p-3 light-bordered" ]
        [ h4 [ class "font-black text-center h4-responsive" ] [ text "Mon espace" ]
        , p [ class "lead mb-0" ] [ AdView.shortView ad ]
        ]


projectView : Model -> Project -> Html Msg
projectView model project =
    div []
        [ header
        , adHeader project.ad
        , photo
        , div [ class ("mt-3 mb-5 " ++ (slidingClass model.projectAnimation)) ]
            [ ul [ class "list-group" ]
                [ stepIndexView DiscoverLand model project.id Checked
                , stepIndexView DiscoverHouse model project.id Checked
                , stepIndexView ConfigureHouse model project.id Current
                , stepIndexView EvaluateFunding model project.id NotYet
                , stepIndexView PhoneCall model project.id NotYet
                , stepIndexView Quotation model project.id NotYet
                , stepIndexView Funding model project.id NotYet
                , stepIndexView VisitLand model project.id NotYet
                , stepIndexView Contract model project.id NotYet
                , stepIndexView BuildingPermit model project.id NotYet
                , stepIndexView Building model project.id NotYet
                , stepIndexView Keys model project.id NotYet
                , stepIndexView AfterSales model project.id NotYet
                ]
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


stepIndexView : ProjectStep -> Model -> ProjectId -> ProjectStepState -> Html Msg
stepIndexView projectStep model projectId projectStepState =
    li [ "list-group-item cp gray-hover" |> class, onClick (ProjectToStep (ProjectStepRoute projectId projectStep)) ]
        [ a []
            [ checkedIcon projectStepState
            , projectStep |> stepTitle |> text
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
                    [ a [ class "btn btn-sm btn-yellow-flash", onClick (StepToProject (ProjectRoute projectId)) ]
                        [ i [ class "fa fa-chevron-left" ] []
                        ]
                    , text title
                    ]
                , view
                ]
            ]
            |> inLayout


discoverLandView : Model -> ProjectId -> String -> Html Msg
discoverLandView model projectId title =
    let
        view =
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


buildingPermitView : Model -> ProjectId -> String -> Html Msg
buildingPermitView model projectId title =
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
