module Messages exposing (..)

import Http
import Navigation
import Routing exposing (Route)
import RemoteData exposing (..)
import Land.Model exposing (..)
import Form exposing (Form)


type Msg
    = NoOp
    | LandCreateResponse (WebData Land)
    | LandFormMsg Form.Msg
    | LandListResponse (WebData (List Land))
    | LandResponse Int (WebData Land)
    | NavigateTo Route
    | UrlChange Navigation.Location
