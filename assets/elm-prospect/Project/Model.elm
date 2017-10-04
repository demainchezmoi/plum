module Project.Model exposing (..)

import Ad.Model exposing (Ad)


type alias ProjectId =
    Int


type alias Project =
    { id : ProjectId
    , ad : Ad
    }


type ProjectStepState
    = Checked
    | Current
    | NotYet


type ProjectStep
    = DiscoverLand
    | DiscoverHouse
    | ConfigureHouse
    | EvaluateFunding
    | PhoneCall
    | Quotation
    | Funding
    | VisitLand
    | Contract
    | BuildingPermit
    | Building
    | Keys
    | AfterSales


stringToProjectStep : String -> Maybe ProjectStep
stringToProjectStep str =
    case str of
        "terrain" ->
            Just DiscoverLand

        "la-maison" ->
            Just DiscoverHouse

        "configurer" ->
            Just ConfigureHouse

        "capacite-financement" ->
            Just EvaluateFunding

        "contact" ->
            Just PhoneCall

        "devis" ->
            Just Quotation

        "financement" ->
            Just Funding

        "visite" ->
            Just VisitLand

        "signature" ->
            Just Contract

        "permis-construire" ->
            Just BuildingPermit

        "construction" ->
            Just Building

        "reception" ->
            Just Keys

        "apres-vente" ->
            Just AfterSales

        _ ->
            Nothing


projectStepToString : ProjectStep -> String
projectStepToString step =
    case step of
        DiscoverLand ->
            "terrain"

        DiscoverHouse ->
            "la-maison"

        ConfigureHouse ->
            "configurer"

        EvaluateFunding ->
            "capacite-financement"

        PhoneCall ->
            "contact"

        Quotation ->
            "devis"

        Funding ->
            "financement"

        VisitLand ->
            "visite"

        Contract ->
            "signature"

        BuildingPermit ->
            "permis-construire"

        Building ->
            "construction"

        Keys ->
            "reception"

        AfterSales ->
            "apres-vente"
