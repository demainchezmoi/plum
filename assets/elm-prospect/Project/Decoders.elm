module Project.Decoders exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Extra exposing ((|:))
import Model exposing (..)
import Ad.Decoders exposing (adDecoder)
import Project.Model exposing (Project, ProjectStepStatus, ProjectStep, stringToProjectStep)


projectStepDecoder : Decoder ProjectStep
projectStepDecoder =
    let
        convert : String -> Decoder ProjectStep
        convert raw =
            case stringToProjectStep raw of
                Just step ->
                    succeed step

                Nothing ->
                    fail "Not found"
    in
        string |> andThen convert


projectStepStatusDecoder : Decoder ProjectStepStatus
projectStepStatusDecoder =
    succeed
        ProjectStepStatus
        |: (field "name" projectStepDecoder)
        |: (field "valid" bool)


projectDecoder : Decoder Project
projectDecoder =
    at [ "data" ] <|
        succeed
            Project
            |: (field "id" int)
            |: (field "ad" adDecoder)
            |: (field "discover_land" bool)
            |: (field "discover_house" bool)
            |: (field "steps" (list projectStepStatusDecoder))
            |: (field "house_color_1" (maybe string))
            |: (field "house_color_2" (maybe string))
            |: (field "contribution" int)
            |: (field "net_income" (maybe int))
            |: (field "phone_call" bool)
