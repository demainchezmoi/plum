module Commands exposing (..)

import Http exposing (..)
import Json.Decode exposing (Decoder)
import Json.Encode exposing (..)
import List exposing ((::))
import Messages exposing (Msg(..))
import Model exposing (ApiToken, Method, Url)
import Project.Model exposing (ProjectId)
import RemoteData exposing (..)


getAuthorizationHeaderValue : String -> String
getAuthorizationHeaderValue apiToken =
    "Token token=\"" ++ apiToken ++ "\""


getAuthorizationHeader : String -> Header
getAuthorizationHeader apiToken =
    header "authorization" (getAuthorizationHeaderValue apiToken)


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


authGet : ApiToken -> Url -> Decoder a -> Request a
authGet apiToken url decoder =
    authentifiedRequest apiToken "GET" url emptyBody [] decoder


authPut : ApiToken -> Url -> Decoder a -> Value -> Request a
authPut apiToken url decoder value =
    authentifiedRequest apiToken "PUT" url (jsonBody value) [] decoder
