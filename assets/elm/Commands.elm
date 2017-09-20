module Commands exposing (..)

import Decoders exposing (landListDecoder)
import Http
import Messages exposing (Msg(..))
import Model exposing (ApiToken)


fetch : ApiToken -> Cmd Msg
fetch apiToken =
    let
        apiUrl =
            String.concat [ "/api/lands/?token=", apiToken ]

        request =
            Http.get apiUrl landListDecoder
    in
        Http.send FetchResult request
