module Types exposing (..)


type Color
    = Red
    | Blue
    | Green
    | Yellow
    | Purple
    | Orange



-- circle on the canvas


type alias Circle =
    { x : Float
    , y : Float
    , color : Color
    }



-- Frontend model


type alias FrontendModel =
    { selectedColor : Maybe Color
    , circles : List Circle
    }



-- Backend Model


type alias BackendModel =
    { circles : List Circle }


type FrontendMsg
    = ColorClicked Color


type ToBackend
    = AddCircle Color


type ToFrontend
    = CircleAdded Circle
    | InitialState (List Circle)
