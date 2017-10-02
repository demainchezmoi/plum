module Messages exposing (..)

import Http
import Navigation
import Routing exposing (Route)
import RemoteData exposing (..)
import Project.Model exposing (Project)


type Msg
    = UrlChange Navigation.Location
    | NavigateTo Route
    | ProjectResponse (WebData Project)
    | ProjectToStep Route
    | StepToProject Route
