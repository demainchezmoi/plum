module Land.View exposing (..)

import Ad.Form exposing (..)
import Form exposing (Form)
import Form.Error exposing (Error)
import Form.Input as Input
import Form.Validate as Validate exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Land.Form exposing (..)
import Land.Model exposing (..)
import Messages exposing (..)
import Model exposing (..)
import RemoteData exposing (..)
import Routing exposing (..)
import ViewHelpers exposing (..)


imageItemView : String -> Form () LandForm -> Int -> Html Form.Msg
imageItemView prefix form i =
    li
        [ class "list-group-item" ]
        [ textInput (prefix ++ "." ++ (toString i)) ("Image url " ++ (toString (i + 1))) form
        , a [ class "text-danger", onClick (Form.RemoveItem "images" i) ] [ text "supprimer" ]
        ]


landFormView : Form () LandForm -> Html Form.Msg
landFormView form =
    Html.form
        [ onSubmit Form.Submit ]
        [ h4 [ class "h4-responsive mt-3 font-bold" ] [ text "Terrain" ]
        , textInput "city" "Ville" form
        , textInput "department" "Département" form
        , textInput "location.lat" "Latitude" form
        , textInput "location.lng" "Longitude" form
        , textInput "price" "Prix" form
        , textInput "surface" "Surface" form
        , textArea "description" "Description" form
        , div [ class "mt-3" ]
            [ div [ class "row" ]
                [ h4 [ class "h4-responsive font-bold col" ] [ text "Photos" ]
                , a [ class "col-auto default-color-text", onClick (Form.Append "images") ] [ text "Ajouter" ]
                ]
            , ul [ class "list-group" ] <|
                List.map (imageItemView "images" form) (Form.getListIndexes "images" form)
            ]
        , div [ class "mt-3" ]
            [ div [ class "row" ]
                [ h4 [ class "h4-responsive font-bold col" ] [ text "Annonces associées" ]
                , a [ class "col-auto default-color-text", onClick (Form.Append "ads") ] [ text "Ajouter" ]
                ]
            , ul [ class "list-group" ] <|
                List.map (adItemFormView "ads" form) (Form.getListIndexes "ads" form)
            ]
        , button
            [ type_ "submit"
            , class "btn btn-default mt-3"
            ]
            [ text "Valider" ]
        ]


landNewView : Model -> Html Msg
landNewView model =
    div []
        [ Html.map LandFormMsg (landFormView model.landForm)
        , a [ class "default-color-text", onClick (NavigateTo LandListRoute) ] [ text "Retour" ]
        ]


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


landShowDetailView : Land -> Html Msg
landShowDetailView land =
    let
        infos =
            String.join " - "
                [ String.concat [ toString land.price, " euros" ]
                , String.concat [ toString land.surface, " m2" ]
                ]

        title =
            String.join "" [ land.city, " (", land.department, ")" ]
    in
        div [ class "list-group-item" ]
            [ div [ class "row" ]
                [ div [ class "col" ]
                    [ div [ class "font-bold" ] [ text title ]
                    , div [ class "" ] [ text infos ]
                    ]
                ]
            ]


landShowSuccessView : Model -> Land -> Html Msg
landShowSuccessView model land =
    div []
        [ landShowDetailView land
        , a [ class "default-color-text", onClick (NavigateTo LandListRoute) ] [ text "Retour" ]
        ]


landListView : Model -> Html Msg
landListView model =
    case model.landList of
        NotAsked ->
            text "Initialising."

        Loading ->
            text "Loading."

        Failure err ->
            text ("Error: " ++ toString err)

        Success landList ->
            div []
                [ h1 [ class "h1-responsive" ] [ text "Terrains" ]
                , p []
                    [ a
                        [ class "default-color-text"
                        , onClick (NavigateTo LandNewRoute)
                        ]
                        [ text "Ajouter" ]
                    ]
                , renderLandList landList
                ]


renderLandList : LandList -> Html Msg
renderLandList landList =
    landList
        |> List.map landItemView
        |> ul [ class "list-group" ]


landItemView : Land -> Html Msg
landItemView land =
    let
        infos =
            String.join " - "
                [ String.concat [ toString land.price, " euros" ]
                , String.concat [ toString land.surface, " m2" ]
                ]

        title =
            String.join "" [ land.city, " (", land.department, ")" ]
    in
        div [ class "list-group-item" ]
            [ div [ class "row" ]
                [ div [ class "col" ]
                    [ div [ class "font-bold" ] [ text title ]
                    , div [ class "" ] [ text infos ]
                    ]
                , div [ class "col-auto" ]
                    [ a
                        [ class "default-color-text"
                        , onClick (NavigateTo (LandShowRoute land.id))
                        ]
                        [ text "Détail" ]
                    ]
                ]
            ]
