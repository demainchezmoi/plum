module Routing exposing (..)

import Navigation
import UrlParser exposing (..)


type Route
    = LandsRoute
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LandsRoute <| s "admin"
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
        LandsRoute ->
            "/lands"

        NotFoundRoute ->
            "/not-found"
