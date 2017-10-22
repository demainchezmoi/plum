module Ad.View exposing (..)

import Ad.Model as AdModel exposing (Ad)
import Html exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (..)
import FormatNumber exposing (format)
import FormatNumber.Locales exposing (frenchLocale)


shortAddText : Ad -> String
shortAddText ad =
    String.join
        " "
        [ ad.land.city
        , "(" ++ ad.land.department ++ ")"
        ]


totalPrice : Ad -> String
totalPrice ad =
    ad
        |> AdModel.totalPrice
        >> toFloat
        >> format { frenchLocale | decimals = 0 }
        >> (\p -> p ++ " €")


shortView : Ad -> Html Msg
shortView ad =
    ad |> shortAddText |> text
