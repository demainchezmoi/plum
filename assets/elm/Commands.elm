module Commands exposing (..)

import Decoders exposing (landListDecoder)
import Http
import Messages exposing (Msg(..))


fetch : Cmd Msg
fetch =
    let
        apiUrl =
            "/api/lands"

        request =
            Http.get apiUrl landListDecoder
    in
        Http.send FetchResult request
