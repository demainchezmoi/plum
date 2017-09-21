module Messages exposing (..)

import Http
import Model exposing (LandList)
import Navigation
import Routing exposing (Route)
import RemoteData exposing (..)


type Msg
    = LandListResponse (WebData LandList)
    | UrlChange Navigation.Location
    | NavigateTo Route
