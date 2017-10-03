module Project.Model exposing (..)

import Ad.Model exposing (Ad)


type alias ProjectId =
    Int


type alias Project =
    { id : ProjectId
    , ad : Ad
    }


type ProjectStep
    = ConfigureHouse
    | CheckLand
    | EvaluateFunding
    | SendFundingDocs
    | ObtainFunding
    | SignContract
    | RequestBuildingPermit
    | ObtainBuildingPermit
    | BuildingBegins
    | ReceiveKeys
    | AfterSales


stringToProjectStep : String -> Maybe ProjectStep
stringToProjectStep str =
    case str of
        "configurer" ->
            Just ConfigureHouse

        "terrain" ->
            Just CheckLand

        "financement" ->
            Just EvaluateFunding

        "envoi-financement" ->
            Just SendFundingDocs

        "financement-valide" ->
            Just ObtainFunding

        "signature" ->
            Just SignContract

        "permis-construire" ->
            Just RequestBuildingPermit

        "permis-construire-obtenu" ->
            Just ObtainBuildingPermit

        "debut-construction" ->
            Just BuildingBegins

        "reception" ->
            Just ReceiveKeys

        "apres-vente" ->
            Just AfterSales

        _ ->
            Nothing


projectStepToString : ProjectStep -> String
projectStepToString step =
    case step of
        ConfigureHouse ->
            "configurer"

        CheckLand ->
            "terrain"

        EvaluateFunding ->
            "financement"

        SendFundingDocs ->
            "envoi-financement"

        ObtainFunding ->
            "financement-valide"

        SignContract ->
            "signature"

        RequestBuildingPermit ->
            "permis-construire"

        ObtainBuildingPermit ->
            "permis-construire-obtenu"

        BuildingBegins ->
            "debut-construction"

        ReceiveKeys ->
            "reception"

        AfterSales ->
            "apres-vente"
