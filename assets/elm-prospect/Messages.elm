module Messages exposing (..)

import Http
import Navigation
import Routing exposing (Route)
import RemoteData exposing (..)
import Project.Model exposing (Project, ProjectId)
import Json.Encode exposing (Value)


type Msg
    = UrlChange Navigation.Location
    | NavigateTo Route
    | ProjectResponse (WebData Project)
    | UpdateProject ProjectId Value
    | ProjectToStep Route
    | StepToProject Route
    | SetHouseColor String
    | ValidateDiscoverLand ProjectId Value
    | ValidateDiscoverLandResponse (WebData Project)
    | ValidateDiscoverHouse ProjectId Value
    | ValidateDiscoverHouseResponse (WebData Project)
    | ValidateConfigureHouse ProjectId
