module Model exposing (..)

import Routing exposing (Route)
import RemoteData exposing (..)
import Project.Model exposing (Project, ProjectId)
import Bootstrap.Carousel as Carousel exposing (defaultStateOptions)


type alias ApiToken =
    String


type alias Method =
    String


type alias Url =
    String


type alias Flags =
    { apiToken : ApiToken
    }


type SlideAnimation
    = EnterRight
    | EnterLeft
    | None


type alias Model =
    { project : WebData Project
    , error : Maybe String
    , loading : Bool
    , apiToken : ApiToken
    , route : Route
    , contribution : Maybe Int
    , netIncome : Maybe Int
    , phoneNumber : Maybe String
    , discoverHouseCarouselState : Carousel.State
    , houseColor : String
    , discoverLandCarouselState : Carousel.State
    , changePhone : Bool
    }


initialModel : ApiToken -> Route -> Model
initialModel apiToken route =
    { project = Loading
    , error = Nothing
    , loading = False
    , apiToken = apiToken
    , route = route
    , contribution = Nothing
    , netIncome = Nothing
    , phoneNumber = Nothing
    , discoverHouseCarouselState =
        Carousel.initialStateWithOptions
            { defaultStateOptions
                | interval = Nothing
            }
    , houseColor = "house_colors/rotterdam.png"
    , discoverLandCarouselState =
        Carousel.initialStateWithOptions
            { defaultStateOptions
                | interval = Nothing
            }
    , changePhone = False
    }
