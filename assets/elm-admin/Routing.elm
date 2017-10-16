module Routing exposing (..)

import Navigation
import UrlParser exposing (..)


type Route
    = LandListRoute
    | NotFoundRoute
    | DashboardRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LandListRoute (s "lands")
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

        DashboardRoute ->
            String.join "/" [ "", "dashboard" ]

        NotFoundRoute ->
            String.join "/" [ "", "not-found" ]
