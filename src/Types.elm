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


type alias ColorSection =
    { color : Color
    , x : Float
    , width : Float
    }



-- Frontend model


type alias FrontendModel =
    { selectedColor : Maybe Color
    , sections : List ColorSection
    }



-- Backend Model


type alias BackendModel =
    { sections : List ColorSection }


type BackendMsg
    = ClientConnected SessionId ClientId
    | NewSection ColorSection


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
    = SectionAdded ColorSection
    | InitialState (List ColorSection)
    | CanvasCleared
