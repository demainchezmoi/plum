module Model exposing (..)


type alias ApiToken =
    String


type alias Model =
    { landList : LandList
    , error : Maybe String
    , apiToken : ApiToken
    }


type alias Land =
    { city : String
    , department : String
    , lat : Float
    , lng : Float
    , price : Int
    , surface : Int
    }


type alias LandList =
    { entries : List Land
    }


type alias Flags =
    { apiToken : ApiToken
    }


initialLandList : LandList
initialLandList =
    { entries = []
    }


initialModel : ApiToken -> Model
initialModel apiToken =
    { landList = initialLandList
    , error = Nothing
    , apiToken = apiToken
    }
