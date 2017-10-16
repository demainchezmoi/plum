module Commands exposing (..)

import Http exposing (..)
import Json.Decode exposing (Decoder)
import Json.Encode exposing (..)
import List exposing ((::))
import Messages exposing (Msg(..))
import Model exposing (ApiToken, Method, Url)
import RemoteData exposing (..)


authentifiedRequest : ApiToken -> Method -> Url -> Body -> List Header -> Decoder a -> Request a
authentifiedRequest apiToken method url body headers decoder =
    request
        { method = method
        , headers = (getAuthorizationHeader apiToken) :: headers
        , url = url
        , body = body
        , expect = expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }


getAuthorizationHeaderValue : String -> String
getAuthorizationHeaderValue apiToken =
    "Token token=\"" ++ apiToken ++ "\""


getAuthorizationHeader : String -> Header
getAuthorizationHeader apiToken =
    header "authorization" (getAuthorizationHeaderValue apiToken)


authGet : ApiToken -> Url -> Decoder a -> Request a
authGet apiToken url decoder =
    authentifiedRequest apiToken "GET" url emptyBody [] decoder
