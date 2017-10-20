port module Ports exposing (..)

import Land.Model exposing (Location)
import Messages exposing (..)
import Json.Encode exposing (Value)


port landMap : Location -> Cmd msg


port removeLandMap : () -> Cmd msg


port mixpanel : ( String, Value ) -> Cmd msg


port loadCarousel : () -> Cmd msg
