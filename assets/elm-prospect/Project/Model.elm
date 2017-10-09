module Project.Model exposing (..)

import Ad.Model exposing (Ad)


type alias ProjectId =
    Int


type alias ProjectStepInfo =
    { step : ProjectStep
    , valid : Bool
    , status : ProjectStepStatus
    }


type alias Project =
    { id : ProjectId
    , ad : Ad
    , discover_house : Bool
    , discover_land : Bool
    , steps : List ProjectStepInfo
    , house_color_1 : Maybe String
    , house_color_2 : Maybe String
    , contribution : Int
    , net_income : Maybe Int
    , phone_call : Bool
    , phone_number : Maybe String
    }


type ProjectStepStatus
    = Checked
    | Current
    | NotYet


type ProjectStep
    = Welcome
    | DiscoverLand
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


stepState : Project -> ProjectStep -> ProjectStepStatus
stepState project projectStep =
    case List.filter (\s -> s.step == projectStep) project.steps of
        { status } :: _ ->
            status

        _ ->
            NotYet


urlToProjectStep : String -> Maybe ProjectStep
urlToProjectStep str =
    case str of
        "bienvenue" ->
            Just Welcome

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
        "welcome" ->
            Just Welcome

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


stringToProjectStepStatus : String -> Maybe ProjectStepStatus
stringToProjectStepStatus str =
    case str of
        "checked" ->
            Just Checked

        "current" ->
            Just Current

        "not_yet" ->
            Just NotYet

        _ ->
            Nothing


projectStepToUrl : ProjectStep -> String
projectStepToUrl step =
    case step of
        Welcome ->
            "bienvenue"

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
