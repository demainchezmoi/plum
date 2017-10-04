module Project.Model exposing (..)

import Ad.Model exposing (Ad)


type alias ProjectId =
    Int


type alias ProjectStepStatus =
    { step : ProjectStep
    , checked : Bool
    }


type alias Project =
    { id : ProjectId
    , ad : Ad
    , steps : List ProjectStepStatus
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
    | Permit
    | Building
    | Keys
    | AfterSales


urlToProjectStep : String -> Maybe ProjectStep
urlToProjectStep str =
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
            Just Permit

        "construction" ->
            Just Building

        "reception" ->
            Just Keys

        "apres-vente" ->
            Just AfterSales

        _ ->
            Nothing


stringToProjectStep : String -> Maybe ProjectStep
stringToProjectStep str =
    case str of
        "discover_land" ->
            Just DiscoverLand

        "discover_house" ->
            Just DiscoverHouse

        "configure_house" ->
            Just ConfigureHouse

        "evaluate_funding" ->
            Just EvaluateFunding

        "phone_call" ->
            Just PhoneCall

        "quotation" ->
            Just Quotation

        "funding" ->
            Just Funding

        "visit_land" ->
            Just VisitLand

        "contract" ->
            Just Contract

        "permit" ->
            Just Permit

        "building" ->
            Just Building

        "keys" ->
            Just Keys

        "after_sales" ->
            Just AfterSales

        _ ->
            Nothing


projectStepToUrl : ProjectStep -> String
projectStepToUrl step =
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

        Permit ->
            "permis-construire"

        Building ->
            "construction"

        Keys ->
            "reception"

        AfterSales ->
            "apres-vente"
