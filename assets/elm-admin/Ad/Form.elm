module Ad.Form exposing (..)

import Form exposing (Form)
import Form.Error exposing (Error)
import Form.Field as Field
import Form.Input as Input
import Form.Validate as Validate exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import ViewHelpers exposing (..)


type alias AdForm =
    { active : Bool
    , house_price : Int
    }


adFormValidation : Validation () AdForm
adFormValidation =
    succeed AdForm
        |> andMap (field "active" bool)
        |> andMap (field "house_price" int)


adItemFormView : String -> Form () a -> Int -> Html Form.Msg
adItemFormView prefix form i =
    li [ class "list-group-item" ]
        [ adFormFields (prefix ++ "." ++ (toString i) ++ ".") form
        , a [ class "text-danger", onClick (Form.RemoveItem "ads" i) ] [ text "supprimer" ]
        ]


initialAdItemField : Field.Field
initialAdItemField =
    Field.group
        [ ( "active", Field.bool True )
        , ( "house_price", Field.string "89000" )
        ]


adFormFields : String -> Form () a -> Html Form.Msg
adFormFields prefix form =
    div []
        [ textInput (prefix ++ "house_price") "Prix de la maison" form
        , checkBoxInput (prefix ++ "active") "Annonce active" form
        ]
