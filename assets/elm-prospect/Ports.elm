port module Ports exposing (..)

import Land.Model exposing (Coordinates)
import Messages exposing (..)


port gmap : String -> Cmd msg
