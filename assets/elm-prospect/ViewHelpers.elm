module ViewHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Http exposing (Error(..))
import Messages exposing (..)
import RemoteData exposing (..)
import Model exposing (..)


loader : Html Msg
loader =
    div [ class "loading-overlay" ]
        [ i [ class "fa fa-spinner fa-spin text-white" ] []
        ]


genericNav : Html Msg
genericNav =
    h5 [ class "ml-header row justify-content-between" ]
        [ div [ class "col" ] [ text " Maisons Léo" ]
        ]


row : List (Html Msg) -> Html Msg
row elements =
    div [ class "row" ] elements


notFoundView : Html Msg
notFoundView =
    text "[404] Cette resource est introuvable."


notAskedView : Html Msg
notAskedView =
    text ""


loadingView : Html Msg
loadingView =
    text "Chargement ..."


unauthorizedView : Html Msg
unauthorizedView =
    text "[401] Identifiez-vous pour accéder à la resource."


forbiddenView : Html Msg
forbiddenView =
    text "[403] Vous ne disposez pas des autorisations nécessaires pour accéder à la ressource."


errorView : Int -> Html Msg
errorView status =
    "["
        ++ toString (status)
        ++ "]"
        ++ "Une erreur est survenue."
        |> text


failureView : Error -> Html Msg
failureView err =
    case err of
        BadUrl str ->
            text "Url mal formattée."

        Timeout ->
            text "Connexion trop longue."

        NetworkError ->
            text "Erreur de réseau."

        BadStatus res ->
            case res.status.code of
                401 ->
                    unauthorizedView

                403 ->
                    forbiddenView

                404 ->
                    notFoundView

                status ->
                    errorView status

        BadPayload pay res ->
            ("Bad payload: " ++ toString res)
                |> text


photoSrc : String -> String
photoSrc s =
    "https://s3-eu-west-1.amazonaws.com/demainchezmoi/cloudfront_assets/images/" ++ s


cardPhoto : String -> Html Msg
cardPhoto s =
    img [ class "img-fluid", src <| photoSrc <| s ] []


photo : String -> Html Msg
photo s =
    img [ class "d-block p-2 img-thumbnail mt-2 img-fluid", src <| photoSrc <| s ] []


photoClass : String -> String -> Html Msg
photoClass string c =
    img
        [ class (c ++ " d-block p-2 img-thumbnail mt-2 img-fluid")
        , src ("https://s3-eu-west-1.amazonaws.com/demainchezmoi/cloudfront_assets/images/" ++ string)
        ]
        []
