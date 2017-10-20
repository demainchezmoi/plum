module Messages exposing (..)

import Http
import Navigation
import Routing exposing (Route)
import RemoteData exposing (..)
import Project.Model exposing (Project, ProjectId)
import Json.Encode exposing (Value)
import Bootstrap.Carousel as Carousel


type Msg
    = NoOp
    | UrlChange Navigation.Location
    | NavigateTo Route
    | ProjectResponse (WebData Project)
    | DiscoverLandProjectResponse (WebData Project)
    | DiscoverHouseProjectResponse (WebData Project)
    | UpdateProject ProjectId Value
    | SetNetIncome String
    | SetContribution String
    | SetPhoneNumber String
    | ValidateDiscoverLand ProjectId Value
    | ValidateDiscoverLandResponse (WebData Project)
    | ValidateDiscoverHouse ProjectId Value
    | ValidateDiscoverHouseResponse (WebData Project)
    | ValidateEvaluateFunding ProjectId
    | ValidateEvaluateFundingResponse (WebData Project)
    | SubmitPhoneNumber ProjectId
    | SubmitPhoneNumberResponse (WebData Project)
    | CarouselHouseMsg Carousel.Msg
    | CarouselLandMsg Carousel.Msg
    | SetHouseColor String
    | ChangePhone
