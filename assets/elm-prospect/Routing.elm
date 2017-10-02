module Routing exposing (..)

import Navigation
import UrlParser exposing (..)
import Project.Model exposing (ProjectId, ProjectStep, stringToProjectStep, projectStepToString)


type Route
    = NotFoundRoute
    | ProjectRoute ProjectId
    | ProjectStepRoute ProjectId ProjectStep


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ProjectRoute (s "projets" </> projectIdMatcher)
        , map ProjectStepRoute (s "projets" </> projectIdMatcher </> projectStepMatcher)
        ]


parse : Navigation.Location -> Route
parse location =
    case UrlParser.parsePath matchers (removePrefix location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


toPath : Route -> String
toPath route =
    case route of
        NotFoundRoute ->
            String.join "/" [ "/mon-espace", "not-found" ]

        ProjectRoute projectId ->
            String.join "/" [ "/mon-espace", "projets", toString projectId ]

        ProjectStepRoute projectId step ->
            String.join "/" [ "/mon-espace", "projets", toString projectId, projectStepToString step ]


removePrefix : Navigation.Location -> Navigation.Location
removePrefix location =
    { location | pathname = location.pathname |> String.dropLeft 11 }


projectStepMatcher : Parser (ProjectStep -> a) a
projectStepMatcher =
    custom "PROJECT_STEP" <|
        \segment -> segment |> stringToProjectStep |> maybeToResult "Project step not found"


projectIdMatcher : Parser (ProjectId -> a) a
projectIdMatcher =
    custom "PROJECT_ID" <|
        \segment -> segment |> String.toInt


maybeToResult : String -> Maybe a -> Result String a
maybeToResult message maybe =
    case maybe of
        Just result ->
            Ok result

        Nothing ->
            Err message
