module Evergreen.Migrate.V2 exposing (..)

import Evergreen.V1.Types
import Evergreen.V2.Types
import Lamdera.Migrations exposing (..)
import Maybe


frontendModel : Evergreen.V1.Types.FrontendModel -> ModelMigration Evergreen.V2.Types.FrontendModel Evergreen.V2.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V1.Types.BackendModel -> ModelMigration Evergreen.V2.Types.BackendModel Evergreen.V2.Types.BackendMsg
backendModel old =
    ModelMigrated ( migrate_Types_BackendModel old, Cmd.none )


frontendMsg : Evergreen.V1.Types.FrontendMsg -> MsgMigration Evergreen.V2.Types.FrontendMsg Evergreen.V2.Types.FrontendMsg
frontendMsg old =
    MsgUnchanged


toBackend : Evergreen.V1.Types.ToBackend -> MsgMigration Evergreen.V2.Types.ToBackend Evergreen.V2.Types.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Evergreen.V1.Types.BackendMsg -> MsgMigration Evergreen.V2.Types.BackendMsg Evergreen.V2.Types.BackendMsg
backendMsg old =
    case old of
        Evergreen.V1.Types.ClientConnected sessionId clientId ->
            MsgMigrated ( Evergreen.V2.Types.ClientConnected sessionId clientId, Cmd.none )

        Evergreen.V1.Types.NewSection section ->
            -- Convert old section to new circle format
            MsgMigrated
                ( Evergreen.V2.Types.NewCircle
                    { color = migrate_Types_Color section.color
                    , size = 80.0 -- Default size for migrated circles
                    }
                , Cmd.none
                )


toFrontend : Evergreen.V1.Types.ToFrontend -> MsgMigration Evergreen.V2.Types.ToFrontend Evergreen.V2.Types.FrontendMsg
toFrontend old =
    case old of
        Evergreen.V1.Types.SectionAdded section ->
            -- Convert old section added message to new circle added message
            MsgMigrated
                ( Evergreen.V2.Types.CircleAdded
                    { color = migrate_Types_Color section.color
                    , size = 80.0 -- Default size for migrated circles
                    }
                , Cmd.none
                )

        Evergreen.V1.Types.InitialState sections ->
            MsgMigrated
                ( Evergreen.V2.Types.InitialState
                    (List.map
                        (\section ->
                            { color = migrate_Types_Color section.color
                            , size = 80.0 -- Default size for migrated circles
                            }
                        )
                        sections
                    )
                , Cmd.none
                )

        Evergreen.V1.Types.CanvasCleared ->
            MsgMigrated ( Evergreen.V2.Types.CanvasCleared, Cmd.none )


migrate_Types_BackendModel : Evergreen.V1.Types.BackendModel -> Evergreen.V2.Types.BackendModel
migrate_Types_BackendModel old =
    { circles =
        List.map
            (\section ->
                { color = migrate_Types_Color section.color
                , size = 80.0 -- Default size for migrated circles
                }
            )
            old.sections
    }


migrate_Types_FrontendModel : Evergreen.V1.Types.FrontendModel -> Evergreen.V2.Types.FrontendModel
migrate_Types_FrontendModel old =
    { selectedColor = old.selectedColor |> Maybe.map migrate_Types_Color
    , circles =
        List.map
            (\section ->
                { color = migrate_Types_Color section.color
                , size = 80.0 -- Default size for migrated circles
                }
            )
            old.sections
    }


migrate_Types_Color : Evergreen.V1.Types.Color -> Evergreen.V2.Types.Color
migrate_Types_Color old =
    case old of
        Evergreen.V1.Types.Color1 ->
            Evergreen.V2.Types.Color1

        Evergreen.V1.Types.Color2 ->
            Evergreen.V2.Types.Color2

        Evergreen.V1.Types.Color3 ->
            Evergreen.V2.Types.Color3

        Evergreen.V1.Types.Color4 ->
            Evergreen.V2.Types.Color4

        Evergreen.V1.Types.Color5 ->
            Evergreen.V2.Types.Color5
