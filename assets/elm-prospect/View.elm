module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (..)
import Model exposing (..)
import Routing exposing (Route(..))
import Project.Model exposing (ProjectId)
import Project.View exposing (projectView)
import RemoteData exposing (..)
import Http exposing (Error(..))


view : Model -> Html Msg
view model =
    section [] [ div [] [ page model ] ]


page : Model -> Html Msg
page model =
    case model.route of
        NotFoundRoute ->
            notFoundView

        ProjectRoute projectId ->
            remoteDataView model.project projectView


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
            res |> toString |> text


remoteDataView : RemoteData Error a -> (a -> Html Msg) -> Html Msg
remoteDataView data view =
    case data of
        Failure err ->
            failureView err

        NotAsked ->
            notAskedView

        Loading ->
            loadingView

        Success data ->
            view data
