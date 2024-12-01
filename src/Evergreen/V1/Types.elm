module Evergreen.V1.Types exposing (..)

import Browser
import Lamdera
import Url


type Color
    = Color1
    | Color2
    | Color3
    | Color4
    | Color5


type alias ColorSection =
    { color : Color
    , x : Float
    , width : Float
    }


type alias FrontendModel =
    { selectedColor : Maybe Color
    , sections : List ColorSection
    }


type alias BackendModel =
    { sections : List ColorSection
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
    | NewSection ColorSection


type ToFrontend
    = SectionAdded ColorSection
    | InitialState (List ColorSection)
    | CanvasCleared
