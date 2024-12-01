module Backend exposing (..)

import Lamdera exposing (ClientId, SessionId, broadcast, sendToFrontend)
import Types exposing (..)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { sections = [] }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        ClientConnected sessionId clientId ->
            -- send current state to new clients
            ( model
            , sendToFrontend clientId (InitialState model.sections)
            )

        NewSection section ->
            -- add new section and broadcast
            ( { model | sections = section :: model.sections }
            , broadcast (SectionAdded section)
            )



-- use createNewSections to calculate new layout for the canvas


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        AddColor color ->
            let
                newSections =
                    createNewSections color model.sections
            in
            -- update the model and broadcast it to all clients
            ( { model | sections = newSections }
            , broadcast (InitialState newSections)
            )


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        ]



-- helper functions
-- calculate new layout when a color is added
-- divide canvas width by number of colors, and
-- position each section consecutively, assigning equal width to each section


calculateSections : List Color -> List ColorSection
calculateSections colors =
    let
        totalColors =
            List.length colors

        sectionWidth =
            100.0 / toFloat totalColors
    in
    List.indexedMap
        (\index color ->
            { color = color
            , x = toFloat index * sectionWidth
            , width = sectionWidth
            }
        )
        colors



-- create new layout when color is added
-- get all colors and calculate positions/sections for all colors


createNewSections : Color -> List ColorSection -> List ColorSection
createNewSections newColor existingSections =
    let
        allColors =
            List.map .color existingSections ++ [ newColor ]
    in
    calculateSections allColors
