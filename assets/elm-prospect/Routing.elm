module Routing exposing (..)

import Navigation
import UrlParser exposing (..)
import Project.Model exposing (ProjectId)


type Route
    = NotFoundRoute
    | ProjectRoute ProjectId


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ProjectRoute (s "projets" </> string) ]


parse : Navigation.Location -> Route
parse location =
    case UrlParser.parseHash matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


toPath : Route -> String
toPath route =
    case route of
        NotFoundRoute ->
            "not-found"

        ProjectRoute projectId ->
            "project/" ++ toString (projectId)
