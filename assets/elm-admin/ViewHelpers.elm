module ViewHelpers exposing (..)

import Form exposing (Form)
import Form.Input as Input
import Html exposing (..)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Http exposing (Error(..))
import RemoteData exposing (..)


errorFor : Form.FieldState () String -> Html Form.Msg
errorFor field =
    case field.liveError of
        Just error ->
            div [ class "error" ] [ text (toString error) ]

        Nothing ->
            text ""


checkBoxInput : String -> String -> Form () a -> Html Form.Msg
checkBoxInput iField iLabel form =
    let
        f =
            Form.getFieldAsBool iField form
    in
        div [ class "form-check" ]
            [ label [ class "form-check-label" ]
                [ Input.checkboxInput f [ class "form-check-input" ]
                , text iLabel
                ]
            ]


textInput : String -> String -> Form () a -> Html Form.Msg
textInput iField iLabel form =
    let
        f =
            Form.getFieldAsString iField form
    in
        div [ class "form-group" ]
            [ label [] [ text iLabel ]
            , Input.textInput f [ class "form-control" ]
            , p [ class "text-danger" ]
                [ errorFor f
                ]
            ]


textArea : String -> String -> Form () a -> Html Form.Msg
textArea iField iLabel form =
    let
        f =
            Form.getFieldAsString iField form
    in
        div [ class "form-group" ]
            [ label [] [ text iLabel ]
            , Input.textArea f [ class "form-control" ]
            , p [ class "text-danger" ]
                [ errorFor f
                ]
            ]


row : List (Html a) -> Html a
row elements =
    div [ class "row" ] elements


notFoundView : Html a
notFoundView =
    text "[404] Cette resource est introuvable."


notAskedView : Html a
notAskedView =
    text ""


loadingView : Html a
loadingView =
    text "Chargement ..."


unauthorizedView : Html a
unauthorizedView =
    text "[401] Identifiez-vous pour accéder à la resource."


forbiddenView : Html a
forbiddenView =
    text "[403] Vous ne disposez pas des autorisations nécessaires pour accéder à la ressource."


errorView : Int -> Html a
errorView status =
    "["
        ++ toString (status)
        ++ "]"
        ++ "Une erreur est survenue."
        |> text


failureView : Error -> Html a
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
