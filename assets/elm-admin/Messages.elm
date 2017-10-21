module Messages exposing (..)

import Http
import Navigation
import Routing exposing (Route)
import RemoteData exposing (..)
import LandList.Model exposing (LandList)
import Land.Model exposing (Land)
import Form exposing (Form)


type Msg
    = NoOp
    | LandCreateResponse (WebData Land)
    | LandFormMsg Form.Msg
    | LandListResponse (WebData LandList)
    | LandResponse (WebData Land)
    | NavigateTo Route
    | UrlChange Navigation.Location
