module ViewHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Http exposing (Error(..))
import Messages exposing (..)
import RemoteData exposing (..)
import Model exposing (..)


inLayout : Html Msg -> Html Msg
inLayout elem =
    div [ class "container" ]
        [ div [ class "row justify-content-center" ]
            [ div [ class "col col-md-10 col-lg-8" ]
                [ elem
                ]
            ]
        ]


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


remoteDataView : Model -> WebData a -> (Model -> a -> Html Msg) -> Html Msg
remoteDataView model data view =
    case data of
        Failure err ->
            failureView err

        NotAsked ->
            notAskedView

        Loading ->
            loadingView

        Success data ->
            view model data
