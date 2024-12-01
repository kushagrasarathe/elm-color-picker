module Frontend exposing (Model, app)

import Browser
import Html exposing (Html, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Lamdera exposing (sendToBackend)
import Types exposing (..)


type alias Model =
    FrontendModel


{-| Lamdera applications define 'app' instead of 'main'.

Lamdera.frontend is the same as Browser.application with the
additional update function; updateFromBackend.

-}
app =
    Lamdera.frontend
        { init = \url key -> init ()
        , update = update
        , updateFromBackend = updateFromBackend
        , subscriptions = \_ -> Sub.none
        , view = view
        , onUrlChange = \_ -> NoOpFrontendMsg
        , onUrlRequest = \_ -> NoOpFrontendMsg
        }


init : () -> ( FrontendModel, Cmd FrontendMsg )
init _ =
    ( { selectedColor = Nothing
      , circles = []
      }
    , Cmd.none
    )


update : FrontendMsg -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
update msg model =
    case msg of
        ColorClicked color ->
            ( { model | selectedColor = Just color }
            , sendToBackend (AddColor color)
              -- send message to backend when color is clicked
            )

        ResetCanvas ->
            ( model
            , sendToBackend ClearCanvas
            )

        UrlClicked urlRequest ->
            ( model, Cmd.none )

        UrlChanged url ->
            ( model, Cmd.none )

        NoOpFrontendMsg ->
            ( model, Cmd.none )


updateFromBackend : ToFrontend -> FrontendModel -> ( FrontendModel, Cmd FrontendMsg )
updateFromBackend msg model =
    case msg of
        CircleAdded circle ->
            ( { model | circles = circle :: model.circles }, Cmd.none )

        InitialState circles ->
            ( { model | circles = circles }, Cmd.none )

        CanvasCleared ->
            ( { model | circles = [] }, Cmd.none )


view : FrontendModel -> Browser.Document FrontendMsg
view model =
    { title = "Color Picker"
    , body =
        [ Html.div
            [ style "background-color" "#F4F6FF"
            , style "height" "100vh"
            , style "display" "flex"
            , style "flex-direction" "column"
            , style "justify-content" "center"
            , style "align-items" "center"
            ]
            [ Html.div [ style "width" "60%" ]
                [ Html.div
                    []
                    [ Html.h1 [] [ Html.text "Elm Color Picker" ]
                    ]
                , -- canvas
                  Html.div
                    [ style "width" "100%"
                    , style "min-height" "500px"
                    , style "max-height" "500px"
                    , style "overflow" "auto"
                    , style "border" "1px solid black"
                    , style "margin-bottom" "20px"
                    , style "background-color" "white"
                    , style "display" "flex"
                    , style "flex-direction" "row"
                    , style "justify-content" "start"
                    , style "flex-wrap" "wrap"
                    , style "gap" "20px"
                    , style "padding" "20px"
                    , style "align-content" "flex-start"
                    ]
                    (List.map viewColorCircle model.circles)
                , Html.div
                    [ style "display" "flex"
                    , style "gap" "2px"
                    , style "border" "1px solid black"
                    , style "width" "100%"
                    , style "padding" "2px"
                    ]
                    [ colorButton Color1
                    , colorButton Color2
                    , colorButton Color3
                    , colorButton Color4
                    , colorButton Color5
                    ]
                , -- Reset button
                  Html.button
                    [ onClick ResetCanvas
                    , style "width" "100%"
                    , style "padding" "10px"
                    , style "background-color" "#ff4444"
                    , style "color" "white"
                    , style "border" "none"
                    , style "border-radius" "4px"
                    , style "cursor" "pointer"
                    , style "font-size" "16px"
                    , style "transition" "background-color 0.3s"
                    , style "hover" "background-color: #ff6666"
                    , style "margin-top" "12px"
                    ]
                    [ text "Reset Canvas" ]
                ]
            ]
        ]
    }


colorButton : Color -> Html FrontendMsg
colorButton color =
    Html.div
        [ style "width" "100%"
        , style "height" "60px"
        , style "background-color" (getColorHex color)
        , style "cursor" "pointer"
        , onClick (ColorClicked color)
        ]
        []



-- helper functions


getColorHex : Color -> String
getColorHex color =
    case color of
        Color1 ->
            "#CDC1FF"

        Color2 ->
            "#6DA9E4"

        Color3 ->
            "#FFD95A"

        Color4 ->
            "#99BC85"

        Color5 ->
            "#213555"



-- render color circles


viewColorCircle : ColorCircle -> Html FrontendMsg
viewColorCircle circle =
    Html.div
        [ style "width" (String.fromFloat circle.size ++ "px")
        , style "height" (String.fromFloat circle.size ++ "px")
        , style "border-radius" "50%"
        , style "background-color" (getColorHex circle.color)
        , style "transition" "all 0.3s ease"
        ]
        []
