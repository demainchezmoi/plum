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
        [ "Maison plus terrain à"
        , ad.land.city
        , "(" ++ ad.land.department ++ ")"
        ]


shortView : Ad -> Html Msg
shortView ad =
    ad |> shortAddText |> text
