module Routing exposing (..)

import Navigation
import UrlParser exposing (..)


type Route
    = LandListRoute
    | LandNewRoute
    | LandShowRoute Int
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LandListRoute (s "admin" </> s "lands")
        , map LandNewRoute (s "admin" </> s "lands" </> s "new")
        , map LandShowRoute (s "admin" </> s "lands" </> int)
        ]


parse : Navigation.Location -> Route
parse location =
    case UrlParser.parsePath matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


toPath : Route -> String
toPath route =
    case route of
        LandListRoute ->
            String.join "/" [ "", "admin", "lands" ]

        LandNewRoute ->
            String.join "/" [ "", "admin", "lands", "new" ]

        LandShowRoute landId ->
            String.join "/" [ "", "admin", "lands", toString landId ]

        NotFoundRoute ->
            String.join "/" [ "", "admin", "not-found" ]
