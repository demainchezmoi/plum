module Messages exposing (..)

import Http
import Model exposing (LandList)


type Msg
    = FetchResult (Result Http.Error LandList)
