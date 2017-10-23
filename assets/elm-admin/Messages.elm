module Messages exposing (..)

import DecodedTypes exposing (..)
import Http
import Navigation
import Routing exposing (Route)
import RemoteData exposing (..)
import Land.Model exposing (..)
import Form exposing (Form)


type FormAction
    = Create
    | Update Int


type Msg
    = NoOp
    | LandCreateResponse (WebData DecodedLand)
    | LandFormMsg FormAction Form.Msg
    | LandEditResponse Int (WebData DecodedLand)
    | LandUpdateResponse Int (WebData DecodedLand)
    | LandDelete Int
    | LandDeleteResponse Int (WebData Bool)
    | LandListResponse (WebData (List DecodedLand))
    | LandResponse Int (WebData DecodedLand)
    | NavigateTo Route
    | UrlChange Navigation.Location
