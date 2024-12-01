module Evergreen.V2.Types exposing (..)

import Browser
import Lamdera
import Url


type Color
    = Color1
    | Color2
    | Color3
    | Color4
    | Color5


type alias ColorCircle =
    { color : Color
    , size : Float
    }


type alias FrontendModel =
    { selectedColor : Maybe Color
    , circles : List ColorCircle
    }


type alias BackendModel =
    { circles : List ColorCircle
    }


type FrontendMsg
    = ColorClicked Color
    | ResetCanvas
    | UrlClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | NoOpFrontendMsg


type ToBackend
    = AddColor Color
    | ClearCanvas


type BackendMsg
    = ClientConnected Lamdera.SessionId Lamdera.ClientId
    | NewCircle ColorCircle


type ToFrontend
    = CircleAdded ColorCircle
    | InitialState (List ColorCircle)
    | CanvasCleared
