module Commands exposing (..)

import Decoders exposing (projectDecoder)
import Http
import Json.Decode exposing (Decoder)
import List exposing ((::))
import Messages exposing (Msg(..))
import Model exposing (ApiToken, Method, Url)
import Project.Model exposing (ProjectId)
import RemoteData exposing (..)


getAuthorizationHeaderValue : String -> String
getAuthorizationHeaderValue apiToken =
    "Token token=\"" ++ apiToken ++ "\""


getAuthorizationHeader : String -> Http.Header
getAuthorizationHeader apiToken =
    Http.header "authorization" (getAuthorizationHeaderValue apiToken)


authentifiedRequest : ApiToken -> Method -> Url -> Http.Body -> List Http.Header -> Decoder a -> Http.Request a
authentifiedRequest apiToken method url body headers decoder =
    Http.request
        { method = method
        , headers = (getAuthorizationHeader apiToken) :: headers
        , url = url
        , body = body
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }


authGet : ApiToken -> Url -> Decoder a -> Http.Request a
authGet apiToken url decoder =
    authentifiedRequest apiToken "GET" url Http.emptyBody [] decoder
