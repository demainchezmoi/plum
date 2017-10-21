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
    | LandListResponse (WebData LandList)
    | UrlChange Navigation.Location
    | NavigateTo Route
    | LandResponse (WebData Land)
    | LandFormMsg Form.Msg
    | CreateLandResponse (WebData Land)
