module Routing exposing (..)

import Navigation
import UrlParser exposing (..)


type Route
    = LandListRoute
    | LandNewRoute
    | LandShowRoute Int
    | NotFoundRoute
    | DashboardRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LandListRoute (s "lands")
        , map LandNewRoute (s "lands" </> s "new")
        , map LandShowRoute (s "lands" </> int)
        , map DashboardRoute (s "dashboard")
        ]


removePrefix : Navigation.Location -> Navigation.Location
removePrefix location =
    { location | pathname = location.pathname |> String.dropLeft 6 }


parse : Navigation.Location -> Route
parse location =
    case UrlParser.parsePath matchers <| removePrefix location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


toPath : Route -> String
toPath route =
    case route of
        LandListRoute ->
            String.join "/" [ "", "lands" ]

        LandNewRoute ->
            String.join "/" [ "", "lands", "new" ]

        LandShowRoute landId ->
            String.join "/" [ "", "lands", toString landId ]

        DashboardRoute ->
            String.join "/" [ "", "dashboard" ]

        NotFoundRoute ->
            String.join "/" [ "", "not-found" ]
