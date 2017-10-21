module Land.View exposing (..)

import Form exposing (Form)
import Form.Error exposing (Error)
import Form.Input as Input
import Form.Validate as Validate exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Land.Model exposing (Land, LandForm)
import Messages exposing (..)
import Model exposing (..)
import RemoteData exposing (..)
import String exposing (join, concat)
import ViewHelpers exposing (..)


landItemView : Land -> Html Msg
landItemView land =
    let
        infos =
            join " - "
                [ concat [ toString land.price, " euros" ]
                , concat [ toString land.surface, " m2" ]
                ]

        title =
            String.join "" [ "Terrain à ", land.city, " (", land.department, ")" ]
    in
        div [ class "card mb-2" ]
            [ div [ class "card-body" ]
                [ div [ class "card-title" ] [ text title ]
                , div [ class "card-text" ] [ text infos ]
                ]
            ]


errorFor : Form.FieldState () String -> Html Form.Msg
errorFor field =
    case field.liveError of
        Just error ->
            -- replace toString with your own translations
            div [ class "error" ] [ text (toString error) ]

        Nothing ->
            text ""


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


imageView : Form () LandForm -> Int -> Html Form.Msg
imageView form i =
    div
        [ class "p-3 light-bordered" ]
        [ textInput ("images." ++ (toString i)) ("Image " ++ (toString (i + 1))) form
        , a [ class "", onClick (Form.RemoveItem "images" i) ] [ text "supprimer" ]
        ]


landFormView : Form () LandForm -> Html Form.Msg
landFormView form =
    Html.form
        [ onSubmit Form.Submit ]
        [ textInput "city" "Ville" form
        , textInput "department" "Département" form
        , textInput "location.lat" "Latitude" form
        , textInput "location.lng" "Longitude" form
        , textInput "price" "Prix" form
        , textInput "surface" "Surface" form
        , textArea "description" "Description" form
        , div [] <| List.map (imageView form) (Form.getListIndexes "images" form)
        , button
            [ type_ "submit"
            , class "btn btn-default"
            ]
            [ text "Valider" ]
        ]


landNewView : Model -> Html Msg
landNewView model =
    Html.map LandFormMsg (landFormView model.landForm)


landShowView : Model -> Html Msg
landShowView model =
    case model.land of
        Failure err ->
            failureView err

        NotAsked ->
            notAskedView

        Loading ->
            loadingView

        Success land ->
            landShowSuccessView model land


landShowSuccessView : Model -> Land -> Html Msg
landShowSuccessView model land =
    landItemView land
