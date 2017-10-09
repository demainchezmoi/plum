module Messages exposing (..)

import Http
import Navigation
import Routing exposing (Route)
import RemoteData exposing (..)
import Project.Model exposing (Project, ProjectId)
import Json.Encode exposing (Value)
import Maps
import Window


type Msg
    = MapsMsg (Maps.Msg Msg)
    | NavigateTo Route
    | NoOp
    | ProjectResponse (WebData Project)
    | Resize Window.Size
    | SetContribution String
    | SetHouseColor1 String
    | SetHouseColor2 String
    | SetNetIncome String
    | SetPhoneNumber String
    | SubmitPhoneNumber ProjectId
    | SubmitPhoneNumberResponse (WebData Project)
    | UpdateProject ProjectId Value
    | UrlChange Navigation.Location
    | ValidateConfigureHouse ProjectId
    | ValidateConfigureHouseResponse (WebData Project)
    | ValidateDiscoverHouse ProjectId Value
    | ValidateDiscoverHouseResponse (WebData Project)
    | ValidateDiscoverLand ProjectId Value
    | ValidateDiscoverLandResponse (WebData Project)
    | ValidateEvaluateFunding ProjectId
    | ValidateEvaluateFundingResponse (WebData Project)
