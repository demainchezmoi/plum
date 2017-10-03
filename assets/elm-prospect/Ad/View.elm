module Ad.View exposing (..)

import Ad.Model exposing (Ad)
import Html exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)


shortAddText : Ad -> String
shortAddText ad =
    String.join
        " "
        [ "Annonce maison plus terrain à"
        , ad.land.city
        , "("
        , ad.land.department
        , ")"
        ]


shortView : Ad -> Html Msg
shortView ad =
    p [ class "lead mt-3 p-3 light-bordered" ] [ ad |> shortAddText |> text ]
