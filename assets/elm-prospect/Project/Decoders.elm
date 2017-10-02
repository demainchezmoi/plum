module Project.Decoders exposing (..)

import Json.Decode as JD exposing (..)
import Json.Decode.Extra exposing ((|:))
import Model exposing (..)
import Project.Model exposing (Project)


projectDecoder : JD.Decoder Project
projectDecoder =
    JD.at [ "data" ] <|
        succeed
            Project
            |: (field "id" int)
