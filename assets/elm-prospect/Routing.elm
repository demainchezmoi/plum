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


removePrefix : Navigation.Location -> Navigation.Location
removePrefix location =
    { location | pathname = location.pathname |> String.dropLeft 11 }


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
            "not-found"

        ProjectRoute projectId ->
            "project/" ++ toString (projectId)
