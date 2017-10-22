module Messages exposing (..)

import DecodedTypes exposing (..)
import Http
import Navigation
import Routing exposing (Route)
import RemoteData exposing (..)
import Land.Model exposing (..)
import Form exposing (Form)
import Json.Decode


type Msg
    = NoOp
    | LandCreateResponse (WebData DecodedLand)
    | LandFormMsg Form.Msg
    | LandListResponse (WebData (List DecodedLand))
    | LandResponse Int (WebData DecodedLand)
    | NavigateTo Route
    | UrlChange Navigation.Location
