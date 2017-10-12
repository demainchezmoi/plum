port module Ports exposing (..)

import Land.Model exposing (Coordinates)
import Messages exposing (..)
import Json.Encode exposing (Value)


port landMap : Coordinates -> Cmd msg


port removeLandMap : () -> Cmd msg


port mixpanel : ( String, Value ) -> Cmd msg
