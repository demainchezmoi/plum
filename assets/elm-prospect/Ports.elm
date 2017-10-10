port module Ports exposing (..)

import Land.Model exposing (Coordinates)
import Messages exposing (..)


port landMap : Coordinates -> Cmd msg


port removeLandMap : () -> Cmd msg
