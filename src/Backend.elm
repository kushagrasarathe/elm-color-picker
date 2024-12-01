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
    ( { circles = [] }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        ClientConnected _ clientId ->
            -- send current state to new clients
            ( model
            , sendToFrontend clientId (InitialState model.circles)
            )

        NewCircle circle ->
            -- add new circle and broadcast it to all clients
            ( { model | circles = circle :: model.circles }
            , broadcast (CircleAdded circle)
            )



-- use createNewSections to calculate new layout for the canvas


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend _ _ msg model =
    case msg of
        AddColor color ->
            let
                newCircles =
                    createNewCircles color model.circles
            in
            -- update the model and broadcast it to all clients
            ( { model | circles = newCircles }
            , broadcast (InitialState newCircles)
            )

        ClearCanvas ->
            ( { model | circles = [] }
            , broadcast CanvasCleared
            )


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Lamdera.onConnect ClientConnected
        ]



-- helper functions
-- creates new circles based on the color and existing circles


createNewCircles : Color -> List ColorCircle -> List ColorCircle
createNewCircles newColor existingCircles =
    let
        allColors =
            List.map .color existingCircles ++ [ newColor ]
    in
    List.map
        (\color ->
            { color = color
            , size = 24
            }
        )
        allColors
