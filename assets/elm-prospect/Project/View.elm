module Project.View exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class)
import Messages exposing (..)
import Model exposing (..)
import Project.Model exposing (..)
import Routing exposing (toPath, Route(..))
import ViewHelpers exposing (remoteDataView)


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


projectView : Model -> Project -> Html Msg
projectView model project =
    div [ class (slidingClass model.projectAnimation) ]
        [ div [ class "intro-1" ]
            [ div [ class "full-bg-img" ] []
            ]
        , div []
            [ ul [ class "list-group" ]
                [ stepIndexView ConfigureHouse model project.id "Configurer ma maison"
                , stepIndexView CheckLand model project.id "Voir le terrain"
                , stepIndexView EvaluateFunding model project.id "Évaluer mes capacités de financement"
                , stepIndexView SendFundingDocs model project.id "Envoyer mes documents"
                , stepIndexView ObtainFunding model project.id "Obtention du financement"
                , stepIndexView SignContract model project.id "Signature du contrat"
                , stepIndexView RequestBuildingPermit model project.id "Demande du permis de construire"
                , stepIndexView ObtainBuildingPermit model project.id "Obtention du permis de construire"
                , stepIndexView BuildingBegins model project.id "Début de la construction"
                , stepIndexView ReceiveKeys model project.id "Réception des clefs"
                , stepIndexView AfterSales model project.id "Service après-vente"
                ]
            ]
        ]


slidingClass : SlideAnimation -> String
slidingClass status =
    case status of
        EnterRight ->
            "enterRight"

        EnterLeft ->
            "enterLeft"

        None ->
            ""


stepIndexView : ProjectStep -> Model -> ProjectId -> String -> Html Msg
stepIndexView projectStep model projectId label =
    li [ "list-group-item" |> class ]
        [ a [ onClick (ProjectToStep (ProjectStepRoute projectId projectStep)) ] [ text label ]
        ]


stepView : Model -> ProjectId -> String -> Html Msg
stepView model projectId txt =
    let
        stepClass =
            String.join " " [ slidingClass model.projectStepAnimation ]
    in
        div [ class stepClass ]
            [ div []
                [ h1 [ class "h1-responsive" ]
                    [ a [ class "btn btn-sm btn-default", onClick (StepToProject (ProjectRoute projectId)) ]
                        [ i [ class "fa fa-chevron-left" ] []
                        ]
                    , text txt
                    ]
                ]
            ]


configureHouseView : Model -> ProjectId -> Html Msg
configureHouseView model projectId =
    stepView model projectId "Configurer ma maison"


checkLandView : Model -> ProjectId -> Html Msg
checkLandView model projectId =
    stepView model projectId "checkLandView"


evaluateFundingView : Model -> ProjectId -> Html Msg
evaluateFundingView model projectId =
    stepView model projectId "evaluateFundingView"


sendFundingDocsView : Model -> ProjectId -> Html Msg
sendFundingDocsView model projectId =
    stepView model projectId "sendFundingDocsView"


obtainFundingView : Model -> ProjectId -> Html Msg
obtainFundingView model projectId =
    stepView model projectId "obtainFundingView"


signContractView : Model -> ProjectId -> Html Msg
signContractView model projectId =
    stepView model projectId "signContractView"


requestBuildingPermitView : Model -> ProjectId -> Html Msg
requestBuildingPermitView model projectId =
    stepView model projectId "requestBuildingPermitView"


obtainBuildingPermitView : Model -> ProjectId -> Html Msg
obtainBuildingPermitView model projectId =
    stepView model projectId "obtainBuildingPermitView"


buildingBeginsView : Model -> ProjectId -> Html Msg
buildingBeginsView model projectId =
    stepView model projectId "buildingBeginsView"


receiveKeysView : Model -> ProjectId -> Html Msg
receiveKeysView model projectId =
    stepView model projectId "receiveKeysView"


afterSalesView : Model -> ProjectId -> Html Msg
afterSalesView model projectId =
    stepView model projectId "afterSalesView"
