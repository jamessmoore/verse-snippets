using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
 
using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /UnrealEngine.com/Temporary/SpatialMath}
 
kill_counter_device := class(creative_device):
 
    @editable
    var ElimMachine : elimination_manager_device = elimination_manager_device{}
    var KillCount : int = 0
    var Players : []player = array{}
    var UIButton : button_loud = button_loud{}
 
    TextForUI<localizes>(Kills : int) : message = "Kills: {Kills}"
 
    OnBegin<override>()<suspends>:void=
        ElimMachine.EliminationEvent.Subscribe(EnemyKilled)
 
        set Players = GetPlayspace().GetPlayers()
        if (Player := Players[0]):
            CreateUI(Player) 
 
    EnemyKilled(Agent : ?agent) : void = 
        set KillCount += 1
        UIButton.SetText(TextForUI(KillCount))
 
    CreateUI(Player : player) : void=
        if(PlayerUI := GetPlayerUI[Player]):
            UIButton.SetText(TextForUI(0))
            MyCanvas : canvas = canvas:
                Slots := array:
                    canvas_slot:
                        Anchors := anchors{Minimum := vector2{X := 0.5, Y := 0.0}, Maximum := vector2{X := 0.5, Y := 0.0}}
                        Offsets := margin{Top := 100.0, Left := 50.0, Right := 50.0, Bottom := 50.0}
                        Alignment := vector2{X := 0.5, Y := 0.5}
                        SizeToContent := true
                        Widget := UIButton
            PlayerUI.AddWidget(MyCanvas)