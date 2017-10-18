module Messages exposing (..)

import Http
import Navigation
import Routing exposing (Route)
import RemoteData exposing (..)
import LandList.Model exposing (LandList)
import Land.Model exposing (Land)


type Msg
    = LandListResponse (WebData LandList)
    | UrlChange Navigation.Location
    | NavigateTo Route
    | LandResponse (WebData Land)
