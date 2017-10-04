module Project.Encoders exposing (..)

import Json.Encode as Encode exposing (..)
import Project.Model exposing (Project)


projectEncoder : Project -> Value
projectEncoder project =
    Encode.object
        [ ( "id", int project.id )
        , ( "discover_land", bool project.discover_land )
        , ( "discover_house", bool project.discover_house )
        ]
