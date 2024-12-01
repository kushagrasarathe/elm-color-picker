module Types exposing (..)

import Browser
import Browser.Navigation exposing (Key)
import Lamdera exposing (ClientId, SessionId, Url)
import Url



-- color palette


type Color
    = Color1
    | Color2
    | Color3
    | Color4
    | Color5



-- color section in canvas


type alias ColorCircle =
    { color : Color
    , size : Float
    }



-- Frontend model


type alias FrontendModel =
    { selectedColor : Maybe Color
    , circles : List ColorCircle
    }



-- Backend Model


type alias BackendModel =
    { circles : List ColorCircle }


type BackendMsg
    = ClientConnected SessionId ClientId
    | NewCircle ColorCircle


type FrontendMsg
    = ColorClicked Color
    | ResetCanvas
    | UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg


type ToBackend
    = AddColor Color
    | ClearCanvas


type ToFrontend
    = CircleAdded ColorCircle
    | InitialState (List ColorCircle)
    | CanvasCleared
