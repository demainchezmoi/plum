module Routing exposing (..)

import Navigation
import UrlParser exposing (..)


type Route
    = LandListRoute
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LandListRoute (s "lands")
        ]


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
        LandListRoute ->
            "/lands"

        NotFoundRoute ->
            "/not-found"
