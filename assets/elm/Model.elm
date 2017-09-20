module Model exposing (..)


type alias Model =
    { landList : LandList
    , error : Maybe String
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


initialLandList : LandList
initialLandList =
    { entries = []
    }


initialModel : Model
initialModel =
    { landList = initialLandList
    , error = Nothing
    }
