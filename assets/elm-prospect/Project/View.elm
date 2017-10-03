module Project.View exposing (..)

import Ad.View as AdView
import Html exposing (..)
import Html.Attributes exposing (class)
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
        ConfigureHouse ->
            configureHouseView model projectId

        CheckLand ->
            checkLandView model projectId

        EvaluateFunding ->
            evaluateFundingView model projectId

        SendFundingDocs ->
            sendFundingDocsView model projectId

        ObtainFunding ->
            obtainFundingView model projectId

        SignContract ->
            signContractView model projectId

        RequestBuildingPermit ->
            requestBuildingPermitView model projectId

        ObtainBuildingPermit ->
            obtainBuildingPermitView model projectId

        BuildingBegins ->
            buildingBeginsView model projectId

        ReceiveKeys ->
            receiveKeysView model projectId

        AfterSales ->
            afterSalesView model projectId


header : Html Msg
header =
    h5 [ class "ml-header" ]
        [ i [ class "fa fa-home" ] []
        , text " Maisons Léo"
        ]


projectView : Model -> Project -> Html Msg
projectView model project =
    div []
        [ header
        , AdView.shortView project.ad
        , div [ class ("mt-3 mb-5 " ++ (slidingClass model.projectAnimation)) ]
            [ ul [ class "list-group" ]
                [ stepIndexView ConfigureHouse model project.id "Configurer ma maison" True
                , stepIndexView CheckLand model project.id "Voir le terrain" True
                , stepIndexView EvaluateFunding model project.id "Ma capacité de financement" False
                , stepIndexView SendFundingDocs model project.id "Mes Documents" False
                , stepIndexView ObtainFunding model project.id "Obtention du financement" False
                , stepIndexView SignContract model project.id "Signature du contrat" False
                , stepIndexView RequestBuildingPermit model project.id "Dépôt du permis de construire" False
                , stepIndexView ObtainBuildingPermit model project.id "Obtention permis de construire" False
                , stepIndexView BuildingBegins model project.id "Phase de la construction" False
                , stepIndexView ReceiveKeys model project.id "Réception des clefs" False
                , stepIndexView AfterSales model project.id "Service après-vente" False
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


checkedIcon : Bool -> Html Msg
checkedIcon checked =
    case checked of
        True ->
            span [ class "fa-stack mr-2" ]
                [ i [ class "fa fa-circle fa-stack-2x yellow-flash-text black-bordered-icon" ] []
                , i [ class "fa fa-check fa-stack-1x" ] []
                ]

        False ->
            span [ class "fa-stack mr-2" ]
                [ i [ class "fa fa-circle fa-stack-2x" ] []
                , i [ class "fa fa-check fa-stack-1x fa-inverse" ] []
                ]


stepIndexView : ProjectStep -> Model -> ProjectId -> String -> Bool -> Html Msg
stepIndexView projectStep model projectId label checked =
    li [ "list-group-item cp gray-hover" |> class, onClick (ProjectToStep (ProjectStepRoute projectId projectStep)) ]
        [ a []
            [ checkedIcon checked
            , text label
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


configureHouseView : Model -> ProjectId -> Html Msg
configureHouseView model projectId =
    let
        view =
            div [] []
    in
        stepView model projectId "Configurer ma maison" view


checkLandView : Model -> ProjectId -> Html Msg
checkLandView model projectId =
    let
        view =
            div [] []
    in
        stepView model projectId "Consulter le terrain" view


evaluateFundingView : Model -> ProjectId -> Html Msg
evaluateFundingView model projectId =
    let
        view =
            div [] []
    in
        stepView model projectId "Ma capacité de financement" view


sendFundingDocsView : Model -> ProjectId -> Html Msg
sendFundingDocsView model projectId =
    let
        view =
            div [] []
    in
        stepView model projectId "Mes documents de financement" view


obtainFundingView : Model -> ProjectId -> Html Msg
obtainFundingView model projectId =
    let
        view =
            div [] []
    in
        stepView model projectId "Obtention de mon financement" view


signContractView : Model -> ProjectId -> Html Msg
signContractView model projectId =
    let
        view =
            div [] []
    in
        stepView model projectId "Signature du contrat" view


requestBuildingPermitView : Model -> ProjectId -> Html Msg
requestBuildingPermitView model projectId =
    let
        view =
            div [] []
    in
        stepView model projectId "Dépot du permis de construire" view


obtainBuildingPermitView : Model -> ProjectId -> Html Msg
obtainBuildingPermitView model projectId =
    let
        view =
            div [] []
    in
        stepView model projectId "Obtebtion du permis de construire" view


buildingBeginsView : Model -> ProjectId -> Html Msg
buildingBeginsView model projectId =
    let
        view =
            div [] []
    in
        stepView model projectId "Phase de construction" view


receiveKeysView : Model -> ProjectId -> Html Msg
receiveKeysView model projectId =
    let
        view =
            div [] []
    in
        stepView model projectId "Remise des clefs" view


afterSalesView : Model -> ProjectId -> Html Msg
afterSalesView model projectId =
    let
        view =
            div [] []
    in
        stepView model projectId "Service après-vente" view
